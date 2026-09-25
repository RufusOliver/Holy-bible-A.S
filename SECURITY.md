# Security

## Reporting a Vulnerability
Please report security issues through the project's issue tracker:
https://github.com/abdelhakimzeraoulia/bible-audio-sync/issues
Mark the issue as containing sensitive security details. Do not:
- commit secrets, tokens, or authentication material to this repository
- include personal data beyond what is required to reproduce the bug
There is no separate private mail alias; the issue tracker is the reporting channel.

## Supported
This is an offline-first, dependency-free single-file web application (index.html)
plus a native Linux GTK/WebKit AppImage wrapper. No server component, no accounts,
no authentication, no cloud sync of user content.

## Threat Model
- The app is fully client-side; all Bible text, audio, dictionaries, and interlincar
  data ship with the repo and load from the local filesystem or the bundled wrapper.
- The only network surface is the bundled text-to-speech / audio backend at
  http://127.0.0.1:5000 (loopback) used when the local Piper/TTS engine is enabled.
- User data (bookmarks, reading position, settings, timestamps) is persisted to
  browser storage only (localStorage with a File System Access API fallback).

## Hardening in place
- Strict Content-Security-Policy:  default-src 'self', script-src 'self' 'unsafe-inline',
  no remote script/style/media origins, connect-src restricted to self and loopback:5000.
- No third-party runtime: no CDNs, no external JS, no analytics, no trackers.
- Offline capability by design; the app does not phone home.
- No build stepper or runtime fetch of remote code.

## Security Advisories
No publicly-disclosed security advisories are currently published for this project.
Maintainers review dependency and data changes (including translations, lexicons,
and audio timestamp data) before release; supply-chain checks are run on workflow
and release changes.

## Data Integrity Notes
- Bible text, verse numbering, Strong's mappings, dictionary entries, and audio
  timestamps are treated as correctness-sensitive and reviewed for regressions on change.
- Deuterocanon (Apocrypha / deuterocanonical books) is carried only by the Apocrypha
  edition; other editions do not include these books.
