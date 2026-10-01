# Source availability and compliance

Ghost Kali is powered by official Kali Linux and follows the official upstream source model.

## Source-backed model

This project is designed to use:

- official Kali Linux package repositories
- official Kali source repositories
- official Kali documentation and package metadata
- official Kali NetHunter guidance for Android-related support

## Compliance expectations

If you redistribute a Kali-derived custom build, keep the following intact:

1. all upstream copyright notices
2. relevant license files from Kali and any packages used
3. source access or source metadata for your modifications
4. attribution to the official Kali Linux and Kali NetHunter projects

## Retrieving source code from Kali

Use the official Kali source repositories when you need package source code:

```bash
apt-get source <package-name>
```

This keeps the project aligned with the official Kali source distribution model.

## NetHunter note

For Android-related functionality, use the official Kali NetHunter project and its supported device guidance. This project is not a substitute for the upstream NetHunter project; it only provides a compatible environment and supporting documentation.

## Responsible use

Use this project only on systems you own or have explicit written permission to test.
