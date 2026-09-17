#!/usr/bin/env bash
# Start the local Piper TTS server for Holy Bible A.S.
# Voices appear in the app's TTS dropdown when this is running.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOICES="en_US-lessac-medium en_GB-alan-medium ar_JO-kareem-medium he_IL-saspeech-medium"

if [ ! -x "$DIR/.venv/bin/python" ]; then
  echo "First run: creating piper venv..."
  python3 -m venv "$DIR/.venv"
  "$DIR/.venv/bin/pip" install -q piper-tts
fi

for v in $VOICES; do
  if [ ! -f "$DIR/voices/$v.onnx" ]; then
    echo "Downloading voice: $v"
    "$DIR/.venv/bin/python" -m piper.download_voices "$v" --data-dir "$DIR/voices"
  fi
done

exec "$DIR/.venv/bin/python" "$DIR/serve.py" --data-dir "$DIR/voices"