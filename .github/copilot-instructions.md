# Copilot Instructions

## Project

Holy Bible A.S is a vanilla HTML, CSS, and JavaScript Bible reader with local Bible data, audio synchronization, text-to-speech, interlinear Strong's data, dictionaries, bookmarks, accessibility controls, and RTL support.

## Repository Structure

- `index.html` contains the primary web application, styles, and JavaScript.
- `data/` contains Bible translations, dictionaries, lexicons, and supporting source data.
- `audio/` contains bundled audio organized by translation.
- `native-linux/` contains the GTK/WebKit wrapper and AppImage build script.
- `dist/` and `src-tauri/target/` are generated output; do not edit generated files directly.
- `build/` contains built AppImage artifacts.

## Change Guidelines

- Preserve the existing dependency-free browser architecture and avoid introducing frameworks or packages unless explicitly required.
- Treat Bible text, verse numbering, Strong's mappings, dictionary entries, audio paths, and timestamps as correctness-sensitive.
- Preserve browser-storage fallbacks and saved bookmarks, timestamps, settings, and reading position.
- Maintain keyboard access, visible focus, accessible labels, readable contrast, mobile layout, RTL reading, and dyslexia-friendly mode.
- Keep resource paths relative so the app works from a static server and inside the native wrapper.
- Do not modify generated output, bundled data, release binaries, or unrelated user changes.
- Keep changes focused and do not commit or create branches unless explicitly requested.

## Validation

For JavaScript or markup changes, run the repository checks used by CI:

```bash
npm ci
node - <<'NODE'
const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');
const scripts = html.match(/<script>([\\s\\S]*?)<\\/script>/g) || [];
for (const [index, script] of scripts.entries()) {
  new Function(script.replace(/<\\/?script>/g, ''));
  console.log(`Script block ${index + 1}: OK`);
}
NODE
```

Also validate all data files when they are changed:

```bash
for file in data/*.js; do node -e "new Function(require('fs').readFileSync('$file', 'utf8'))" || exit 1; done
```

For native Linux changes, use `./native-linux/build-appimage.sh` when GTK 3, WebKitGTK 4.1, GCC, `pkg-config`, and `curl` are available. Report any environment limitation instead of claiming the AppImage was tested.

## Working Style

Before editing, identify the smallest owning code path and a nearby validation check. Make the smallest focused change, validate it immediately, and review the final diff for data, accessibility, RTL, mobile, storage, and resource-path regressions.
