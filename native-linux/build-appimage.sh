#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BUILD_DIR="${RUNNER_TEMP:-/tmp}/holy-bible-a-s-appimage"
APP_DIR="$BUILD_DIR/AppDir"
OUTPUT_DIR="$ROOT_DIR/build"
LINUXDEPLOY="$BUILD_DIR/linuxdeploy-x86_64.AppImage"
# Pin linuxdeploy by sha256 (continuous build as of 2026-08-23). Override with
# LINUXDEPLOY_SHA256=<hash> when intentionally adopting a newer build.
LINUXDEPLOY_SHA256="${LINUXDEPLOY_SHA256:-421ca71d5c69ea97c6309276232990d43df1dcece0edfaa26bbf926ff96ed12e}"
ICON="$BUILD_DIR/holy-bible-a-s.svg"

# WebKitGTK spawns its helper processes (WebKitNetworkProcess,
# WebKitWebProcess, WebKitGPUProcess) from an absolute directory baked into
# libwebkit2gtk at compile time (PKGLIBEXECDIR: /usr/lib/webkit2gtk-4.1 on
# Arch/Fedora, /usr/lib/<triplet>/webkit2gtk-4.1 on Debian/Ubuntu). The
# WEBKIT_EXEC_PATH override was removed in WebKitGTK 2.46, so inside an
# AppImage the only fix is to rewrite that string in the bundled library.
# It is patched to "././lib/webkit2gtk-4.1", which main.c resolves by
# chdir'ing into $APPDIR/usr before any WebKit call. The replacement is shorter than
# both original strings, so it is written over the old bytes and NUL-padded;
# the ELF layout is untouched.
HELPER_PATH_OLD="/usr/lib/webkit2gtk-4.1"
HELPER_PATH_NEW="././lib/webkit2gtk-4.1"

rm -rf "$BUILD_DIR" "$OUTPUT_DIR"
mkdir -p "$APP_DIR/usr/bin" "$APP_DIR/usr/share/holy-bible-a-s" "$OUTPUT_DIR"
cp "$ROOT_DIR/index.html" "$APP_DIR/usr/share/holy-bible-a-s/"
cp -R "$ROOT_DIR/data" "$ROOT_DIR/audio" "$APP_DIR/usr/share/holy-bible-a-s/"
cp "$ROOT_DIR/native-linux/holy-bible-a-s.desktop" "$BUILD_DIR/"
cp "$ROOT_DIR/native-linux/holy-bible-a-s.svg" "$ICON"

gcc "$ROOT_DIR/native-linux/main.c" -o "$APP_DIR/usr/bin/holy-bible-a-s" \
    $(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.1)

# Bundle the WebKit helper processes and the injected bundle. linuxdeploy
# only follows linked libraries and never sees these; WebKit aborts with
# SIGTRAP when they are missing.
HELPER_DIR=""
for candidate in \
    "$(pkg-config --variable=helperdir webkit2gtk-4.1 2>/dev/null || true)" \
    "$(pkg-config --variable=libdir webkit2gtk-4.1)/webkit2gtk-4.1" \
    "/usr/lib/webkit2gtk-4.1"; do
    if [[ -n $candidate && -x $candidate/WebKitNetworkProcess ]]; then
        HELPER_DIR=$candidate
        break
    fi
done
if [[ -z $HELPER_DIR ]]; then
    echo "error: WebKitGTK helper processes not found" >&2
    exit 1
fi
mkdir -p "$APP_DIR/usr/lib/webkit2gtk-4.1"
for helper in "$HELPER_DIR"/WebKit*Process; do
    cp "$helper" "$APP_DIR/usr/lib/webkit2gtk-4.1/"
done
if [[ -d $HELPER_DIR/injected-bundle ]]; then
    cp -R "$HELPER_DIR/injected-bundle" "$APP_DIR/usr/lib/webkit2gtk-4.1/"
fi

curl --fail --location --silent --show-error \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    --output "$LINUXDEPLOY"
echo "${LINUXDEPLOY_SHA256}  ${LINUXDEPLOY}" | sha256sum --check --strict -
chmod +x "$LINUXDEPLOY"

# Deploy libraries, desktop file and icons into the AppDir. linuxdeploy
# scans every ELF already present in the AppDir, so the manually copied
# helpers and injected bundle get their dependencies bundled too. No
# --output here: packaging happens with appimagetool below, after the
# helper-path patch.
APPIMAGE_EXTRACT_AND_RUN=1 "$LINUXDEPLOY" \
    --appdir "$APP_DIR" \
    --executable "$APP_DIR/usr/bin/holy-bible-a-s" \
    --desktop-file "$BUILD_DIR/holy-bible-a-s.desktop" \
    --icon-file "$ICON"

# Rewrite the compile-time helper directory inside the bundled library.
WEBKIT_LIB=$(find "$APP_DIR/usr/lib" -name 'libwebkit2gtk-4.1.so.0*' ! -type l | head -1)
if [[ -z $WEBKIT_LIB ]]; then
    echo "error: bundled libwebkit2gtk-4.1.so.0 not found" >&2
    exit 1
fi
python3 - "$WEBKIT_LIB" "$HELPER_PATH_OLD" "$HELPER_PATH_NEW" <<'PY'
import sys

library, old, new = sys.argv[1], *sys.argv[2:]
old_b, new_b = old.encode(), new.encode()
blob = open(library, "rb").read()

# Longest first: the bare-directory literal is a prefix of the
# injected-bundle one, so replacing it first would corrupt the latter.
patterns = [
    (old_b + b"/injected-bundle/", new_b + b"/injected-bundle/"),
    (old_b + b"\x00", new_b + b"\x00"),
]
for pat, rep in patterns:
    assert len(rep) <= len(pat), f"{rep!r} does not fit in {pat!r}"
    count = blob.count(pat)
    if count == 0:
        sys.exit(
            f"error: {pat!r} not found in {library}; this WebKitGTK does not "
            "lay out its helper paths where expected"
        )
    pad = b"\x00" * (len(pat) - len(rep))
    blob = blob.replace(pat, rep + pad)
    print(f"patched {count} occurrence(s): {pat.decode(errors='replace')!r}")
open(library, "wb").write(blob)
PY

# GIO modules carry glib-networking's TLS backends; without them HTTPS dies
# with "TLS support is not available" once the app talks to the network.
GIO_MODULES="$(pkg-config --variable=giomoduledir gio-2.0)"
mkdir -p "$APP_DIR/usr/lib/gio/modules"
cp "$GIO_MODULES"/*.so "$APP_DIR/usr/lib/gio/modules/"

# Package with linuxdeploy's --output appimage. Its runtime falls back to
# extracting into /tmp/.mount_* on systems without FUSE2 (e.g. Arch), which
# plain appimagetool runtimes do not. Packaging only squashes the AppDir and
# does not re-deploy libraries, but the helper-path patch is verified anyway.
pushd "$BUILD_DIR" >/dev/null
APPIMAGE_EXTRACT_AND_RUN=1 "$LINUXDEPLOY" \
    --appdir "$APP_DIR" \
    --executable "$APP_DIR/usr/bin/holy-bible-a-s" \
    --desktop-file "$BUILD_DIR/holy-bible-a-s.desktop" \
    --icon-file "$ICON" \
    --output appimage

if ! grep -q "$HELPER_PATH_NEW" "$WEBKIT_LIB"; then
    echo "error: packaged library lost the helper-path patch" >&2
    exit 1
fi
find . -maxdepth 1 -type f -name '*.AppImage' ! -name 'linuxdeploy-*.AppImage' \
    -exec mv -- {} "$OUTPUT_DIR/" \;
popd >/dev/null

echo "$OUTPUT_DIR/Holy_Bible_A.S-x86_64.AppImage"
