# WEB Audio - World English Bible (Complete, Gen to Rev)

Source: David Williams recording via AudioTreasure.com (2000-2001), Basil Sands variant via ebible.org. Dedicated to Public Domain (no restriction).
- Upstream: https://www.audiotreasure.com/webindex.htm (WEB_OT_Audio.zip 900MB + WEB_NT_Audio.zip 300MB)
- Alternative: https://ebible.org/engwebu/mp3/ (OT Genesis only + NT) and https://publicdomainaudiobibles.com/WEBW.html
- License: Public Domain

## Complete Coverage
This folder now contains **1189 chapter MP3s** covering **Genesis to Revelation** (929 OT + 260 NT chapters), no partial audio.

- OT: 929 files (Genesis 50, Exodus 40, Leviticus 27, Numbers 36, Deuteronomy 34, Joshua 24, Judges 21, Ruth 4, 1Samuel 31, 2Samuel 24, 1Kings 22, 2Kings 25, 1Chronicles 29, 2Chronicles 36, Ezra 10, Nehemiah 13, Esther 10, Job 42, Psalm 150, Proverbs 31, Ecclesiastes 12, Song of Solomon 8, Isaiah 66, Jeremiah 52, Lamentations 5, Ezekiel 48, Daniel 12, Hosea 14, Joel 3, Amos 9, Obadiah 1, Jonah 4, Micah 7, Nahum 3, Habakkuk 3, Zephaniah 3, Haggai 2, Zechariah 14, Malachi 4)
- NT: 260 files (Matthew 28, Mark 16, Luke 24, John 21, Acts 28, Romans 16, 1Cor 16, 2Cor 13, Gal 6, Eph 6, Philippians 4, Colossians 4, 1Thess 5, 2Thess 3, 1Tim 6, 2Tim 4, Titus 3, Philemon 1, Hebrews 13, James 5, 1Peter 5, 2Peter 3, 1John 5, 2John 1, 3John 1, Jude 1, Revelation 22)

Naming: `book_chapter_web.mp3` lowercase (e.g. `genesis_1_web.mp3`, `psalm_23_web.mp3`, `matt_1_web.mp3`, `revelation_22_web.mp3`). Some books use abbreviations (`matt` for Matthew, `1cor` for 1 Corinthians, `psalm` for Psalms) as per upstream.

## Usage
- `index.html` audio loader supports `audio/web/*.mp3` via `audioFileInput` or direct `audio.src = 'audio/web/genesis_1_web.mp3'`
- For `native-linux` AppImage, files are bundled via `native-linux/build-appimage.sh`
- To regenerate: `./audio/web/download.sh --sample` (2 files) or download zips from upstream and run rename script (see `download.sh`)

## Size
- ~1.4GB total (OT 995M + NT 353M). Previous `audio/kjv:254M (211 files, partial)` and `audio/ylt:1.1G (46 files, partial)` remain for legacy; `audio/web` is the first complete Gen-to-Rev set.

See `docs/github-copilot-agents-application-card.md` for responsible AI handling of external data.
