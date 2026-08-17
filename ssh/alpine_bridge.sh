#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ALPINE_HOST="${ALPINE_HOST:-192.168.1.50}"
ALPINE_USER="${ALPINE_USER:-root}"
KEY="/data/data/com.termux/files/home/black-locust-rmh/ssh/id_ed25519_blrmh"
KNOWN="/data/data/com.termux/files/home/black-locust-rmh/ssh/known_hosts"

mkdir -p "$(dirname "$KEY")"

if [ ! -f "$KEY" ]; then
  ssh-keygen -t ed25519 -f "\( KEY" -N "" -C "black-locust-rmh- \)(date -u +%Y%m%d)"
  echo "NEW KEY GENERATED"
fi

echo "=== PUBLIC KEY ==="
cat "${KEY}.pub"
echo "=================="
echo "On Alpine: mkdir -p /root/.ssh && chmod 700 /root/.ssh"
echo "cat >> /root/.ssh/authorized_keys  (paste key then Ctrl-D)"
echo "chmod 600 /root/.ssh/authorized_keys"
echo "rc-update add sshd default && service sshd start"

SSH_OPTS="-i $KEY -o UserKnownHostsFile=$KNOWN -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 -o BatchMode=yes"

echo "Testing \( {ALPINE_USER}@ \){ALPINE_HOST} ..."
if ssh \( SSH_OPTS " \){ALPINE_USER}@${ALPINE_HOST}" "echo ALPINE_ALIVE && uname -a"; then
  echo "SSH BRIDGE LIVE"
  ssh \( SSH_OPTS " \){ALPINE_USER}@${ALPINE_HOST}" "mkdir -p /root/black-locust-rmh/ledger"
  echo "Remote ledger directory ready"
else
  echo "SSH FAILED — check IP, key on Alpine, sshd status"
  exit 1
fi
