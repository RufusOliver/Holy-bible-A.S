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

The 50-agent company roster lives in `.github/agents/*.agent.md` (loaded by opencode and usable in Copilot flows). All are invoked with `@<name>` or via Tab cycling for primary agents; subagents run through the task dispatcher.

**Primary / leadership**
- `bible-app-maintainer` - maintain app, fix bugs, add features
- `copilot-cloud` - GitHub Copilot cloud agent for async issue-to-PR automation (`@copilot` assignment, ephemeral firewalled env, automated CodeQL scanning)
- `bible-product-planner` - plan features, break work into tasks, route to specialist agents

**Middle managers (dispatch to specialists)**
- `product-manager` - cross-department delivery coordination
- `data-manager` - Data & Translations dept
- `dictionaries-manager` - Dictionaries & Lexicons dept
- `audio-manager` - Audio & TTS dept
- `ui-manager` - UI/UX & Accessibility dept
- `storage-manager` - Storage & State dept
- `native-manager` - Native & Packaging dept
- `qa-manager` - Testing & QA dept
- `ci-release-manager` - CI/CD & Release dept
- `security-manager` - Security & Review dept
- `dumbdown-manager` - reports to the boss in plain, simple language
- `adhd-short-page-manager` - reports to the boss in short scannable pages

**Data & Translations** - `bible-data-engineer`, `translation-loader-engineer`, `verse-numbering-engineer`, `original-languages-engineer`, `translation-editor`, `interlinear-engineer`, `parallel-reading-engineer`, `search-engineer`, `metadata-engineer`, `data-integrity-auditor`

**Dictionaries & Lexicons** - `dictionary-engineer`, `lexicon-engineer`, `hebrew-greek-concordance-engineer`, `dictionary-ui-engineer`

**Audio & TTS** - `audio-sync-engineer`, `tts-engineer`, `audio-asset-manager`, `audio-timestamp-engineer`, `playback-state-engineer`, `audio-controls-engineer`

**UI/UX & Accessibility** - `ui-producer`, `accessibility-engineer`, `rtl-engineer`, `dyslexia-mode-engineer`, `responsive-mobile-engineer`, `theme-settings-engineer`, `keyboard-navigation-engineer`, `typography-reader-engineer`

**Storage & State** - `storage-engineer`, `bookmarks-engineer`, `settings-persistence-engineer`

**Native & Packaging** - `native-linux-engineer`, `appimage-builder`, `packaging-release-engineer`

**Testing & QA** - `qa-test-engineer`, `edge-case-tester`, `regression-tester`, `performance-tester`, `test-automation-engineer`

**CI/CD & Release** - `ci-release-engineer`, `workflow-maintainer`, `dependency-automation-engineer`

**Security & Review** - `bible-pr-reviewer` (review diffs for regressions, data integrity, accessibility), `pr-malware-checker` (malware/supply-chain security review for PRs, workflows, dependencies), `security-hardener`, `supply-chain-auditor`, `code-quality-reviewer`

For the cloud agent, assign issue to `@copilot` or comment `@copilot` on issue/PR.

## Workflows
- `ai-agent.yml` - pull_request: AI review, auto-fix, PR summary
- `ai-chat.yml` - issue_comment @ai: chat agent
- `copilot-setup-steps.yml` - Copilot cloud agent environment setup (checkout, Node 22, npm ci, syntax checks)
- `ci.yml`, `codeql.yml`, `build.yml` - CI, security, AppImage build
