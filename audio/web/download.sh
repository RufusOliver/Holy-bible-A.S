#!/usr/bin/env bash
set -euo pipefail
# Download WEB (World English Bible) chapter MP3s from ebible.org (Basil Sands, Public Domain)
# Sources:
# - ebible.org/engwebu/mp3/ - OT: 02_GEN_01.mp3, NT: WEB-073-John_03.mp3 etc
# - Mirror: audiotreasure.com, publicdomainaudiobibles.com
# License: Public Domain
BASE="https://ebible.org/engwebu/mp3"
MODE="${1:---sample}"

if [ "$MODE" = "--sample" ]; then
  echo "Fetching WEB sample chapters (Genesis 1, John 3)..."
  cd "$(dirname "$0")"
  curl -L -o genesis_1_web.mp3 "$BASE/02_GEN_01.mp3"
  curl -L -o john_3_web.mp3 "$BASE/WEB-073-John_03.mp3"
  ls -lh *.mp3
  echo "Done. Verify: ls -lh audio/web/"
elif [ "$MODE" = "--all" ]; then
  echo "Fetching full WEB listing..."
  cd "$(dirname "$0")"
  # Download all mp3s via wget if available
  if command -v wget >/dev/null; then
    wget -r -np -nd -A "*.mp3" "$BASE/"
    echo "Downloaded all MP3s. Renaming to book_chapter_web.mp3 convention..."
    echo "OT already as 02_GEN_01.mp3 -> genesis_1_web.mp3 mapping needed via script"
    ls -lh | head -n 20
  else
    echo "wget not found, use curl per file. See README.md"
    curl -s "$BASE/" | grep -o 'href="[^"]*\.mp3"' | head -n 20
  fi
else
  echo "Usage: $0 [--sample|--all]"
  cat README.md
fi
