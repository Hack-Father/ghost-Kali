# Ghost Kali: Kali-derived custom build

Ghost Kali is a Kali-derived custom build project designed for building and running a Kali-based environment on supported systems, including Windows through WSL and Android through Kali NetHunter-compatible userspace tools.

This project does not claim to replace the official Kali Linux or NetHunter projects. Instead, it is built from official upstream sources, keeps upstream attribution intact, and provides source-backed build guidance for a Kali-based environment.

## Project goal

The goal of Ghost Kali is to provide:

- a Kali-based rootfs/build workflow for supported Linux environments
- scripts for Windows WSL setup and Android NetHunter-compatible installation
- source-backed build guidance using official Kali mirrors and package sources
- clear notices for upstream licensing and source availability

## Important legal and licensing notice

This repository is intentionally structured as a Kali-derived project, not an un-attributed fork of Kali Linux.

The official Kali Linux project and the Kali NetHunter project remain the upstream sources. Ghost Kali preserves attribution and GPL-compliance expectations by:

- using official Kali package repositories and source mirrors
- keeping upstream notices and license materials intact
- labeling this project clearly as a Kali-derived custom build
- providing source availability information for project modifications

## Source-backed build model

This project supports a source-backed model rather than a private, closed-source “full Kali distribution” bundle.

A compliant source-backed build uses:

- official Kali repositories
- official Kali source Debian package repositories
- upstream licensing files and notices
- a build script that fetches official rootfs and source packages
- a README and notices that identify upstream authors and licenses

## Repository layout

- `build-kali-rootfs.sh` — build a Kali-based rootfs from official upstream packages
- `NOTICE` — upstream attribution and project notice
- `SOURCE_AVAILABILITY.md` — GPL/source-availability guidance
- `INSTALL_WINDOWS.md` — Windows installation using WSL 2 or VirtualBox
- `INSTALL_ANDROID.md` — Android installation guidance for Kali NetHunter-compatible environments
- `install-windows-wsl.ps1` — Windows WSL setup helper
- `install-nethunter-rootless.sh` — Android install helper for NetHunter-compatible rootless setup

## Supported installation models

### Windows

Use WSL 2 with Kali Linux, or use a Kali VM with VirtualBox.

### Android

Use Kali NetHunter Rootless or a supported NetHunter-compatible setup. This project is designed to work as a Kali-derived environment and to provide userspace helpers, not to replace the official NetHunter project.

## Build workflow

Use the build helper from the repository:

```bash
bash build-kali-rootfs.sh
```

This script is designed to:

- set up a Kali apt source configuration
- fetch official package metadata
- optionally fetch Debian source packages for the build root
- stage custom project files on top of a Kali-derived rootfs
- print instructions for custom packaging or deployment

## Recommended usage

This project is intended for:

- educational lab builds
- penetration testing labs
- authorized security research environments
- custom deployments built on official Kali packages

Use all security tools only on systems you own or have explicit, written authorization to test.

## Source and upstream references

Official upstream references:

- Kali Linux: https://www.kali.org/
- Kali documentation: https://www.kali.org/docs/
- NetHunter: https://www.kali.org/get-kali/#kali-mobile

## Legal note

This is a derivative/custom build model, not a replacement for the official Kali Linux or NetHunter projects. Full source and package distribution must preserve upstream licensing, copyright notices, and source-availability obligations.

If you redistribute a derivative build, you must continue to provide access to the relevant source code and preserve all upstream notices as required by the applicable license terms.

## Disclaimer

Ghost Kali is intended for legitimate, authorized security testing and education only. Unauthorized activity is illegal and unsupported.
