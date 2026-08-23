#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BUILD_DIR="${RUNNER_TEMP:-/tmp}/holy-bible-a-s-appimage"
APP_DIR="$BUILD_DIR/AppDir"
OUTPUT_DIR="$ROOT_DIR/releases"
LINUXDEPLOY="$BUILD_DIR/linuxdeploy-x86_64.AppImage"
# Pin linuxdeploy by sha256 (continuous build as of 2026-08-23). Override with
# LINUXDEPLOY_SHA256=<hash> when intentionally adopting a newer build.
LINUXDEPLOY_SHA256="${LINUXDEPLOY_SHA256:-421ca71d5c69ea97c6309276232990d43df1dcece0edfaa26bbf926ff96ed12e}"
ICON="$BUILD_DIR/holy-bible-a-s.svg"

rm -rf "$BUILD_DIR" "$OUTPUT_DIR"
mkdir -p "$APP_DIR/usr/bin" "$APP_DIR/usr/share/holy-bible-a-s" "$OUTPUT_DIR"
cp "$ROOT_DIR/index.html" "$APP_DIR/usr/share/holy-bible-a-s/"
cp -R "$ROOT_DIR/data" "$ROOT_DIR/audio" "$APP_DIR/usr/share/holy-bible-a-s/"
cp "$ROOT_DIR/native-linux/holy-bible-a-s.desktop" "$BUILD_DIR/"
cp "$ROOT_DIR/native-linux/holy-bible-a-s.svg" "$ICON"

gcc "$ROOT_DIR/native-linux/main.c" -o "$APP_DIR/usr/bin/holy-bible-a-s" \
    $(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.1)

curl --fail --location --silent --show-error \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    --output "$LINUXDEPLOY"
echo "${LINUXDEPLOY_SHA256}  ${LINUXDEPLOY}" | sha256sum --check --strict -
chmod +x "$LINUXDEPLOY"

pushd "$BUILD_DIR" >/dev/null
APPIMAGE_EXTRACT_AND_RUN=1 "$LINUXDEPLOY" \
    --appdir "$APP_DIR" \
    --executable "$APP_DIR/usr/bin/holy-bible-a-s" \
    --desktop-file "$BUILD_DIR/holy-bible-a-s.desktop" \
    --icon-file "$ICON" \
    --output appimage
find . -maxdepth 1 -type f -name '*.AppImage' ! -name 'linuxdeploy-*.AppImage' -exec mv -- {} "$OUTPUT_DIR/" \;
popd >/dev/null

find "$OUTPUT_DIR" -maxdepth 1 -type f -name '*.AppImage' ! -name 'linuxdeploy-*.AppImage' -print -quit
