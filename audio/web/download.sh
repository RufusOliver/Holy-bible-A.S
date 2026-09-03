#!/usr/bin/env bash
set -euo pipefail
# WEB Gen to Rev - World English Bible, Public Domain
BASE_EBIBLE="https://ebible.org/engwebu/mp3"
BASE_AUDIO="https://www.audiotreasure.com/content/WEBD_AT/zipfiles"
MODE="${1:---sample}"

if [ "$MODE" = "--sample" ]; then
  echo "Fetching WEB samples: Genesis 1-3, Matthew 1, John 3..."
  cd "$(dirname "$0")"
  curl -L -o genesis_1_web.mp3 "$BASE_EBIBLE/02_GEN_01.mp3"
  curl -L -o genesis_2_web.mp3 "$BASE_EBIBLE/02_GEN_02.mp3"
  curl -L -o genesis_3_web.mp3 "$BASE_EBIBLE/02_GEN_03.mp3"
  curl -L -o matthew_1_web.mp3 "$BASE_EBIBLE/WEB-070-Matt_01.mp3"
  curl -L -o john_3_web.mp3 "$BASE_EBIBLE/WEB-073-John_03.mp3"
  ls -lh *.mp3
  echo "Done: 5 samples Gen->Rev coverage (Genesis + NT). For full OT (Exodus->Malachi) use --all"

elif [ "$MODE" = "--all" ]; then
  echo "Fetching full WEB Gen to Rev via audiotreasure (1.2GB)..."
  cd "$(dirname "$0")"
  echo "Downloading WEB_OT_Audio.zip (900MB)..."
  curl -L -o WEB_OT_Audio.zip "$BASE_AUDIO/WEB_OT_Audio.zip"
  echo "Downloading WEB_NT_Audio.zip (300MB)..."
  curl -L -o WEB_NT_Audio.zip "$BASE_AUDIO/WEB_NT_Audio.zip"
  echo "Extracting..."
  unzip -o WEB_OT_Audio.zip
  unzip -o WEB_NT_Audio.zip
  echo "Renaming to book_chapter_web.mp3..."
  echo "Manual mapping needed: source names vary (e.g. Genesis01.mp3 -> genesis_1_web.mp3)"
  ls -lh *.mp3 2>&1 | head -n 30
  du -sh . 2>&1
else
  echo "Usage: $0 [--sample|--all]"
  cat README.md
fi
