#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(pwd)"
status=0
patterns=(
'curl[[:space:]]+[^|]*\\|[[:space:]]*(ba|z)?sh'
'wget[[:space:]]+[^|]*\\|[[:space:]]*(ba|z)?sh'
'nc[[:space:]].*(-e|-c)'
'netcat[[:space:]].*(-e|-c)'
'authorized_keys'
'crontab[[:space:]]+-'
'/etc/cron'
'/etc/systemd/system'
'systemctl[[:space:]]+(enable|start)'
'(^|[^[:alnum:]_])eval[[:space:]]*\\('
'base64[[:space:]]+-d.*\\|'
'curl.*(password|token|secret|cookie)'
'wget.*(password|token|secret|cookie)'
)
for file in $(find "$ROOT" -type f -name '*.sh' -not -path '*/.git/*'); do
  for pattern in "${patterns[@]}"; do
    if grep -nE -- "$pattern" "$file" >/tmp/ghost-audit.$$ 2>/dev/null; then
      echo "[REVIEW] $file"; cat /tmp/ghost-audit.$$; status=1
    fi
  done
done
rm -f /tmp/ghost-audit.$$
if [ "$status" -eq 0 ]; then echo '[PASS] No configured high-risk patterns found.'; else echo '[REVIEW REQUIRED] Potentially risky patterns found.'; exit 1; fi
