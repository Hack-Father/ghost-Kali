# Source availability and licensing guidance

This project follows a Kali-derived source-backed build model.

## What this means

This repository does not claim to ship the complete, private source of the entire Kali Linux project in a closed, non-source form. Instead, it provides:

- a build script for a Kali-based rootfs
- installation guides for supported environments
- attribution and legal notices
- instructions for obtaining upstream source packages and source code from official Kali repositories

## Required upstream source handling

If you redistribute a custom Kali-derived build, you should:

1. Keep upstream copyright and license notices intact.
2. Retain the original package license metadata.
3. Provide access to the source code for your modifications.
4. Include upstream notices for Kali Linux and any upstream components used.
5. Use official source repositories when possible.

## Source retrieval from official Kali repositories

Use the official Kali source repositories:

```bash
apt-get source <package-name>
```

or download official source metadata from the Kali package archive.

## NetHunter note

Kali NetHunter must be treated as its own upstream project when used on Android. This project does not replace or override the official NetHunter project. It only provides a compatible userspace helper and install guidance.

## Compliance reminder

You may build and redistribute a Kali-derived project, but you must respect the license obligations and source availability requirements of the upstream work and packages used.

Use all tools only on systems you own or have explicit permission to test.
