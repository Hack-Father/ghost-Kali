# Ghost Kali Security Policy

Ghost Kali installation and setup scripts must be transparent and auditable.

The repository MUST NOT contain:
- hidden downloads;
- curl | bash, wget | sh, or equivalent remote-code execution;
- reverse shells;
- nc/netcat callbacks;
- SSH-key installation without explicit user action;
- credential harvesting;
- password or token collection;
- suspicious or hidden persistence;
- cron/systemd persistence;
- arbitrary eval of downloaded or user-controlled content.

The following are NOT prohibited by this policy, but must remain transparent and documented where applicable:
- encoded payload execution;
- destructive commands;
- covert exfiltration;
- external servers, including third-party servers.

Legitimate network access must be documented and limited to the service required for the stated feature. Official Kali infrastructure is preferred for Kali installation components.

Run `bash ./audit-ghost-kali.sh` to perform the repository's static safety audit.
