# Contributing to Holy Bible A.S

Thanks for helping with Holy Bible A.S! This project is **vibe-coded**: the maintainer directs, and AI agents (Copilot, opencode, ChatGPT) write most of the code. Expect AI-written JS, iterative prompting, and human review for correctness.

## Getting started

1. Fork and clone the repository.
2. Install [Git LFS](https://git-lfs.com/) and pull the bundled audio:
   ```bash
   git lfs install
   git lfs pull
   ```
3. Open [`index.html`](index.html) in a modern browser, or serve the repository with any static file server:
   ```bash
   python3 -m http.server 8000
   ```

No build step or package installation is required for the web app.

## Making changes

- Keep the single-file `index.html` architecture. No frameworks or packages unless explicitly required.
- Treat Bible text, verse numbering, Strong's mappings, dictionary entries, audio paths, and timestamps as **correctness-sensitive**. Do not normalize casually.
- Preserve browser-storage behavior (localStorage + File System Access API fallback) for bookmarks, timestamps, settings, and reading position.
- Maintain keyboard access, visible focus, labels, contrast, RTL reading, dyslexia mode, and mobile layout.
- Keep resource paths relative so the app works from a static server and inside the native wrapper.
- Do not edit generated output (`dist/`, `build/`) or vendored data without a clear reason.
- Use the agent company in `.github/agents/*.agent.md` — invoke primary agents with `@<name>`; subagents run through the task dispatcher.

### Language naming

- Refer to the ancient Greek of the critical texts (Nestle1904, SBLGNT, NTGT, EPT/ElzevirTR) as **Koine Greek** — never bare "Greek".
- Refer to the Hebrew of the critical texts (WLCa, WLC, WLCC, HAC, DHNT) as **Paleo-Hebrew** — never bare "Hebrew".
- Keep proper dictionary titles (e.g., "Thayer's Greek Lexicon", "Strong's Hebrew Dictionary") and the English "Good News Translation" key `GNT` unchanged.

## Validation

Run these checks before opening a pull request:

### JavaScript syntax check for index.html

```bash
node - <<'NODE'
const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');
const scripts = html.match(/<script>([\s\S]*?)<\/script>/g) || [];
for (const [i, s] of scripts.entries()) { new Function(s.replace(/<\/?script>/g, '')); console.log(`Script block ${i+1}: OK`); }
NODE
```

### Data files validation

```bash
for file in data/*.js; do node -e "new Function(require('fs').readFileSync('$file', 'utf8'))" || exit 1; done
```

### Native Linux changes

Use `./native-linux/build-appimage.sh` when GTK 3, WebKitGTK 4.1, GCC, `pkg-config`, and `curl` are available. If the environment cannot build the AppImage, report the limitation instead of claiming it was tested.

CI runs the same checks; see the workflows in `.github/workflows/`.

## Pull request checklist

- [ ] Focused change with a clear description
- [ ] JS syntax and data files validate locally
- [ ] No regressions in accessibility, RTL, mobile layout, storage, or resource paths
- [ ] Existing bookmarks, timestamps, settings, and reading position remain compatible
- [ ] No generated output, vendored data, or unrelated changes included