# WEB Audio - World English Bible

Source: Basil Sands recording, dedicated to Public Domain.
- Upstream: https://ebible.org/engwebu/mp3/ (ebible.org)
- Mirror: https://www.audiotreasure.com/webindex.htm (David Williams) and https://publicdomainaudiobibles.com/WEBW.html (Winfred Hinson)
- License: Public Domain (no restriction)

This folder should contain chapter MP3s named as `book_chapter_web.mp3` (lowercase, e.g. `genesis_1_web.mp3`, `john_3_web.mp3`) to match existing `audio/kjv/*.mp3` and `audio/ylt/*.mp3` conventions used by `index.html` audio loader and `native-linux` packaging.

Use `download.sh` to fetch from ebible.org.

See `docs/github-copilot-agents-application-card.md` for responsible AI handling of external data.

Not yet committed: audio files are large (full WEB OT+NT ~1.2GB). Run the download script to populate.
