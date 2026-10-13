#!/bin/bash
# Installs cronjob.txt as the CURRENT user's crontab (run as pi, not root),
# and (re)creates the sudoers rule that lets control.py restart mopidy without a password.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ $EUID -eq 0 ]]; then
    echo "Run as the normal user (pi), not root" >&2
    exit 1
fi

SUDOERS=/etc/sudoers.d/mopidy-restart
SYSTEMCTL="$([[ -x /usr/bin/systemctl ]] && echo /usr/bin/systemctl || echo /bin/systemctl)"
echo "$USER ALL=(root) NOPASSWD: $SYSTEMCTL restart mopidy" | sudo tee "$SUDOERS" > /dev/null
sudo chmod 440 "$SUDOERS"
sudo visudo -cf "$SUDOERS"

crontab "$DIR/cronjob.txt"
echo "Installed crontab for $USER:"
crontab -l | grep -v '^#' | grep -v '^$'
