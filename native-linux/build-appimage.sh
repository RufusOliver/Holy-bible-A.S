#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BUILD_DIR="${RUNNER_TEMP:-/tmp}/holy-bible-a-s-appimage"
APP_DIR="$BUILD_DIR/AppDir"
OUTPUT_DIR="$ROOT_DIR/native-linux/appimage"
LINUXDEPLOY="$BUILD_DIR/linuxdeploy-x86_64.AppImage"

rm -rf "$BUILD_DIR" "$OUTPUT_DIR"
mkdir -p "$APP_DIR/usr/bin" "$APP_DIR/usr/share/holy-bible-a-s" "$OUTPUT_DIR"
cp "$ROOT_DIR/index.html" "$APP_DIR/usr/share/holy-bible-a-s/"
cp -R "$ROOT_DIR/data" "$ROOT_DIR/audio" "$APP_DIR/usr/share/holy-bible-a-s/"
cp "$ROOT_DIR/native-linux/holy-bible-a-s.desktop" "$BUILD_DIR/"
cp "$ROOT_DIR/src-tauri/icons/icon.png" "$BUILD_DIR/holy-bible-a-s.png"

gcc "$ROOT_DIR/native-linux/main.c" -o "$APP_DIR/usr/bin/holy-bible-a-s" \
    $(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.1)

curl --fail --location --silent --show-error \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
    --output "$LINUXDEPLOY"
chmod +x "$LINUXDEPLOY"

pushd "$BUILD_DIR" >/dev/null
APPIMAGE_EXTRACT_AND_RUN=1 "$LINUXDEPLOY" \
    --appdir "$APP_DIR" \
    --executable "$APP_DIR/usr/bin/holy-bible-a-s" \
    --desktop-file "$BUILD_DIR/holy-bible-a-s.desktop" \
    --icon-file "$BUILD_DIR/holy-bible-a-s.png" \
    --output appimage
find . -maxdepth 1 -type f -name '*.AppImage' ! -name 'linuxdeploy-*.AppImage' -exec mv -- {} "$OUTPUT_DIR/" \;
popd >/dev/null

find "$OUTPUT_DIR" -maxdepth 1 -type f -name '*.AppImage' ! -name 'linuxdeploy-*.AppImage' -print -quit
