# Ghost Kali Security Policy

Ghost Kali installation and setup scripts must be transparent and auditable.

The repository MUST NOT contain:
- hidden downloads or unexplained external servers;
- curl|bash, wget|sh, or equivalent remote-code execution;
- reverse shells or Netcat callbacks;
- SSH-key installation without explicit user action;
- credential, password, token, cookie, or secret harvesting;
- hidden cron/systemd or other persistence;
- arbitrary eval of downloaded or user-controlled content;
- encoded or obfuscated payload execution;
- destructive disk/filesystem operations without a clearly displayed target and explicit confirmation;
- covert data exfiltration.

Legitimate network access must be documented and limited to the service required for the installation. Official Kali infrastructure is permitted when identified clearly.

Run `bash ./audit-ghost-kali.sh` to perform the repository's static safety audit.
