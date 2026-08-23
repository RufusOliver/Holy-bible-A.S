# Holy Bible A.S

Holy Bible A.S is an accessible Bible reader with audio synchronization, more than 60 Bible translations, text-to-speech, interlinear Strong's data, dictionaries, bookmarks, and parallel translation reading.

## Run in a browser

No package installation or build step is required. Open [`index.html`](index.html) in a modern browser, or serve the repository with any static file server.

For example:

```bash
python3 -m http.server 8000
```

Then visit <http://localhost:8000>.

## Linux AppImage

A prebuilt 64-bit Linux application is available at [`releases/Holy_Bible_A.S-x86_64.AppImage`](releases/Holy_Bible_A.S-x86_64.AppImage). Make it executable and run it:

```bash
chmod +x releases/Holy_Bible_A.S-x86_64.AppImage
./releases/Holy_Bible_A.S-x86_64.AppImage
```

## Build the AppImage

The native application uses GTK 3 and WebKitGTK 4.1. Install the build dependencies for your Linux distribution, including:

- GCC
- `pkg-config`
- GTK 3 development files
- WebKitGTK 4.1 development files
- `curl`

On Debian or Ubuntu, the usual packages are:

```bash
sudo apt install build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.1-dev curl
```

Build from the repository root:

```bash
./native-linux/build-appimage.sh
```

The generated AppImage is written to [`releases/`](releases/). The script downloads the current `linuxdeploy` binary during the build.

## Features

- Browse Bible books, chapters, and translations
- Play bundled audio for supported translations
- Synchronize audio with verses using timestamps
- Use browser text-to-speech with selectable voices and speed
- Compare translations in parallel view
- Inspect Strong's numbers and dictionary entries
- Save bookmarks and reading position
- Enable dyslexia-friendly reading controls and reading ruler
- Support right-to-left Bible text

## Repository layout

| Path | Purpose |
| --- | --- |
| [`index.html`](index.html) | Web application and user interface |
| [`data/`](data/) | Bible translations and reference data |
| [`audio/`](audio/) | Bundled Bible audio |
| [`native-linux/`](native-linux/) | GTK/WebKit wrapper and AppImage build script |
| [`releases/`](releases/) | Built Linux AppImage artifacts |

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE).