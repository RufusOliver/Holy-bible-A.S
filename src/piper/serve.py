#!/usr/bin/env python3
import argparse
import io
import json
import re
import wave
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

from piper import PiperVoice, SynthesisConfig

VOICE_BASE = None
DEFAULT_VOICE = None
LOADED = {}


def available_voices():
    return sorted(p.name[:-len(".onnx")] for p in Path(VOICE_BASE).glob("*.onnx"))


def load_voice(name):
    if name not in LOADED:
        model = f"{VOICE_BASE}/{name}.onnx"
        LOADED[name] = PiperVoice.load(model, use_cuda=False)
    return LOADED[name]


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass

    def _headers(self, code=200, ctype="application/json", extra=None):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()

    def do_OPTIONS(self):
        self._headers()

    def do_GET(self):
        if self.path.startswith("/voices"):
            self._headers()
            self.wfile.write(json.dumps({"voices": available_voices()}).encode())
        else:
            self._headers(404)
            self.wfile.write(b'{"error":"not found"}')

    def do_POST(self):
        if not self.path.startswith("/synthesize"):
            self._headers(404)
            self.wfile.write(b'{"error":"not found"}')
            return
        length = int(self.headers.get("Content-Length", 0))
        body = json.loads(self.rfile.read(length) or b"{}")
        text = body.get("text") or ""
        voice = body.get("voice") or DEFAULT_VOICE
        length_scale = float(body.get("length_scale", 1.0))
        try:
            v = load_voice(voice)
        except Exception as e:
            self._headers(400)
            self.wfile.write(json.dumps({"error": f"voice {voice}: {e}"}).encode())
            return
        cfg = SynthesisConfig(length_scale=length_scale)
        buf = io.BytesIO()
        with wave.open(buf, "wb") as wav:
            wav.setnchannels(1)
            wav.setsampwidth(2)
            wav.setframerate(v.config.sample_rate)
            for chunk in v.synthesize(text, cfg):
                if chunk.audio_int16_bytes:
                    wav.writeframes(chunk.audio_int16_bytes)
        data = buf.getvalue()
        self._headers(200, "audio/wav", {"Content-Length": str(len(data))})
        self.wfile.write(data)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=5000)
    ap.add_argument("--voice", default="en_US-lessac-medium")
    ap.add_argument("--data-dir", default="voices")
    args = ap.parse_args()
    VOICE_BASE = args.data_dir
    DEFAULT_VOICE = re.sub(r"\.onnx$", "", args.voice)
    load_voice(DEFAULT_VOICE)
    print(f"Piper serving {DEFAULT_VOICE} on http://{args.host}:{args.port}")
    ThreadingHTTPServer((args.host, args.port), Handler).serve_forever()