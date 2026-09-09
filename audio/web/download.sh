#!/usr/bin/env bash
set -euo pipefail
# Download WEB (World English Bible) chapter MP3s - Complete Gen to Rev
# Upstream: audiotreasure.com (David Williams, Public Domain)
# Alternative: ebible.org/engwebu/mp3 (Genesis + NT only)
BASE_OT="https://www.audiotreasure.com/content/WEBD_AT/zipfiles/WEB_OT_Audio.zip"
BASE_NT="https://www.audiotreasure.com/content/WEBD_AT/zipfiles/WEB_NT_Audio.zip"
MODE="${1:---sample}"
if [ "$MODE" = "--sample" ]; then
  echo "Fetching WEB sample chapters (Genesis 1, John 3) from ebible.org..."
  cd "$(dirname "$0")"
  curl -L -o genesis_1_web.mp3 "https://ebible.org/engwebu/mp3/02_GEN_01.mp3"
  curl -L -o john_3_web.mp3 "https://ebible.org/engwebu/mp3/WEB-073-John_03.mp3"
  ls -lh *.mp3
elif [ "$MODE" = "--all" ]; then
  echo "Fetching full WEB OT+NT (1189 files, ~1.2GB) from audiotreasure.com..."
  cd "$(dirname "$0")"
  curl -L -o WEB_OT_Audio.zip "$BASE_OT"
  curl -L -o WEB_NT_Audio.zip "$BASE_NT"
  echo "Extracting..."
  unzip -q -o WEB_OT_Audio.zip
  unzip -q -o WEB_NT_Audio.zip
  echo "Renaming to book_chapter_web.mp3..."
  for f in *.mp3; do
    # Skip already renamed
    if [[ "$f" == *_web.mp3 ]]; then continue; fi
    base=$(basename "$f" .mp3)
    rest=$(echo "$base" | cut -d'_' -f2-)
    if echo "$rest" | grep -q "_"; then chap=$(echo "$rest" | rev | cut -d'_' -f1 | rev); book=$(echo "$rest" | rev | cut -d'_' -f2- | rev)
    else chap=$(echo "$rest" | grep -o "[0-9]*$"); book=$(echo "$rest" | sed "s/${chap}$//"); fi
    book=$(echo "$book" | sed 's/_$//'); book_lc=$(echo "$book" | tr '[:upper:]' '[:lower:]' | sed 's/soloman/solomon/g')
    chap_num=$(echo "$chap" | sed 's/^0*//'); [ -z "$chap_num" ] && chap_num=0
    mv -n "$f" "${book_lc}_${chap_num}_web.mp3"
  done
  # Fix Lamentations
  for f in lam_*_web.mp3; do [ -f "$f" ] && mv -n "$f" "${f/lam_/lamentations_}"; done 2>/dev/null || true
  rm -f WEB_OT_Audio.zip WEB_NT_Audio.zip
  echo "Done: $(ls *.mp3 | wc -l) files, $(du -sh . | cut -f1)"
else
  echo "Usage: $0 [--sample|--all]"
  cat README.md
fi
