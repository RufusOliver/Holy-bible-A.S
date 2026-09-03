# WEB Audio - World English Bible

Source: Basil Sands / David Williams / Winfred Hinson recordings, dedicated to Public Domain.
- Upstream: https://ebible.org/engwebu/mp3/ (Genesis + NT only, 309 files: 02_GEN_01-50 + WEB-070-Matt to WEB-096-REV)
- Full OT+NT via audiotreasure.com: https://www.audiotreasure.com/webindex.htm
  - WEB_OT_Audio.zip (900MB) + WEB_NT_Audio.zip (300MB) = ~1.2GB
  - Also: https://publicdomainaudiobibles.com/WEBW.html (WEBW_OT.zip 995MB + WEBW_NT.zip 320MB)
- License: Public Domain

This folder contains chapter MP3s named `book_chapter_web.mp3` (lowercase, e.g. `genesis_1_web.mp3`, `john_3_web.mp3`) matching `audio/kjv/*.mp3` and `audio/ylt/*.mp3` conventions for `index.html` loader.

Current: 5 samples (genesis 1-3, matthew 1, john 3) = ~20MB for validation. Full Bible = Genesis to Revelation (66 books, 1189 chapters).

Use `./download.sh --sample` for 5 samples or `./download.sh --all` to fetch full zips from audiotreasure (requires ~1.2GB).

Note: ebible.org/mp3 only has Genesis + NT (309 files). For Exodus to Malachi (OT beyond Genesis), use audiotreasure zips.

See `docs/github-copilot-agents-application-card.md` for responsible AI handling.
