# Holy Bible A.S

Holy Bible A.S is an accessible Bible reader with audio synchronization, more than 60 Bible translations, text-to-speech, interlinear Strong's data, 10 dictionaries, bookmarks, parallel translation reading, and dyslexia-friendly accessibility features.

## Run in a browser

No package installation or build step is required. Open [`index.html`](index.html) in a modern browser, or serve the repository with any static file server.

```bash
python3 -m http.server 8000
```

Then visit <http://localhost:8000>.

## Linux AppImage

A prebuilt 64-bit Linux application is available from the [latest release](https://github.com/RufusOliver/Holy-bible-A.S/releases/latest). Download the `.AppImage` file, make it executable, and run it:

```bash
chmod +x Holy_Bible_A.S-*.AppImage
./Holy_Bible_A.S-*.AppImage
```

## Build the AppImage

The native application uses GTK 3 and WebKitGTK 4.1. Install the build dependencies for your Linux distribution:

**Debian / Ubuntu:**

```bash
sudo apt install build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.1-dev curl python3
```

**Arch Linux:**

```bash
sudo pacman -S --needed base-devel gtk3 webkit2gtk-4.1 curl python3
```

Build from the repository root:

```bash
./native-linux/build-appimage.sh
```

The generated AppImage is written to [`build/`](build/).

## Features

- **60+ Bible translations** — English, Greek, Hebrew, Arabic, Aramaic
- **Audio player** — Local MP3 files for KJV/YLT, Archive.org streaming for ASV and others
- **Verse sync** — Timestamp-based audio synchronization with verse highlighting
- **TTS Audiobook** — Text-to-speech with word-level highlighting, voice selection, speed control, and auto-advance (OT/NT/Whole Bible loops)
- **Parallel reading** — Compare up to 3 translations side by side
- **10 Dictionaries** — Strong's, Thayer's, BDB, Vine's, Easton's, Smith's, Fausset's, Hitchcock's, JFB, Gill's
- **Interlinear mode** — Strong's numbers on every word with click-to-define
- **Bookmarks** — Save reading position with File System Access API folder storage + localStorage fallback
- **Dyslexia-friendly mode** — OpenDyslexic font, adjustable font size/letter spacing/line height, 6 background presets, reading ruler
- **RTL support** — Arabic, Hebrew, and Aramaic with proper right-to-left layout
- **GitHub release checker** — Checks for the latest Linux AppImage on startup

## Keyboard shortcuts

| Key | Action |
| --- | --- |
| `Space` | Play / Pause audio |
| `T` | Start TTS Audiobook (or stop) |
| `←` / `→` | Seek backward / forward 3 seconds |
| `Escape` | Close dictionary popup |

## Repository layout

| Path | Purpose |
| --- | --- |
| [`index.html`](index.html) | Web application (HTML + CSS + JS in one file) |
| [`data/`](data/) | Bible translations, dictionaries, and reference data |
| [`audio/`](audio/) | Bundled Bible audio (KJV, YLT) |
| [`native-linux/`](native-linux/) | GTK/WebKit wrapper and AppImage build script |

## CI/CD

| Workflow | Trigger | Purpose |
| --- | --- | --- |
| CI | Push to main, PRs | Validates JS syntax, data files, HTML structure |
| Build | Push to main, PRs, manual | Builds native Linux AppImage |
| CodeQL | Push to main, PRs, weekly | Security scanning |
| Auto Version | Push to main | Bumps patch version in package.json |
| Release | Tag push (`v*`) | Publishes AppImage to GitHub Releases |

## License

This project is licensed under the Reciprocal Public Domain Dedication. See [`LICENSE`](LICENSE).
