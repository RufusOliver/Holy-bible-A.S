# Holy Bible A.S - Agent Instructions

> **Vibe-coded project.** The maintainer hates JavaScript and builds this app with AI. Most code is generated or heavily assisted by AI agents (Copilot, opencode, ChatGPT). Expect AI-written JS, iterative prompting, and human review for correctness. If you are an AI agent, you are the primary code author.

This is the Holy Bible A.S project: a vanilla HTML/CSS/JavaScript Bible reader (single-file `index.html`) with native Linux GTK/WebKit AppImage packaging. It is maintained vibe-coded style: AI writes the JS, the human directs.

## Repository Shape
- `index.html` - primary UI, CSS, JavaScript (single-file app)
- `data/` - Bible translations, dictionaries (Strong's, Thayer's, BDB, Vine's, Easton's, Smith's, Fausset's, Hitchcock's, JFB, Gill's), lexicons, interlinear data
- `audio/` - local audio assets organized by translation
- `native-linux/` - GTK/WebKit wrapper and AppImage build script (`build-appimage.sh`)
- `dist/` and `build/` - generated output; do not edit

## Constraints
- Preserve vanilla HTML/CSS/JS architecture; no frameworks unless explicitly required.
- Treat Bible text, verse numbering, Strong's mappings, dictionary entries, audio timestamps as correctness-sensitive. Do not normalize casually.
- Preserve browser-storage behavior (localStorage + File System Access API fallback) for bookmarks, timestamps, settings, reading position.
- Maintain keyboard access, visible focus, labels, contrast, RTL reading, dyslexia mode (OpenDyslexic, 6 backgrounds, reading ruler), mobile layout.
- Keep resource paths relative (works from static server and native wrapper).
- Do not edit generated output or vendored data.

## Validation
```bash
# JS syntax check for index.html
node - <<'NODE'
const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');
const scripts = html.match(/<script>([\\s\\S]*?)<\/script>/g) || [];
for (const [i, s] of scripts.entries()) { new Function(s.replace(/<\/?script>/g, '')); console.log(`Script block ${i+1}: OK`); }
NODE

# Data files validation
for file in data/*.js; do node -e "new Function(require('fs').readFileSync('$file', 'utf8'))" || exit 1; done
```

For native Linux changes: `./native-linux/build-appimage.sh` (requires GTK 3, WebKitGTK 4.1, GCC, pkg-config, curl).

## Agents
- `bible-app-maintainer` (primary) - maintain app, fix bugs, add features
- `bible-pr-reviewer` (subagent) - review diffs for regressions, data integrity, accessibility
- `pr-malware-checker` (subagent) - malware/supply-chain security review for PRs, workflows, dependencies

Invoke with `@bible-app-maintainer`, `@bible-pr-reviewer`, `@pr-malware-checker` or via Tab cycling for primary agents.

## Workflows
- `ai-agent.yml` - pull_request: AI review, auto-fix, PR summary
- `ai-chat.yml` - issue_comment @ai: chat agent
- `ci.yml`, `codeql.yml`, `build.yml` - CI, security, AppImage build
