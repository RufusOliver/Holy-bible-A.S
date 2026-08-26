# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in Holy Bible A.S, please report it by opening an issue or contacting the maintainer directly.

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact

We will respond within 7 days and work to fix confirmed issues promptly.

## Scope

This is a static web application with no server-side code. Security concerns are limited to:
- Client-side code execution (XSS)
- Data storage (localStorage, File System Access API)
- External resource loading (Archive.org streaming, CDN fonts)

The application does not collect, transmit, or store user data on any server.
