#!/data/data/com.termux/files/usr/bin/bash
# black-locust-rmh Alpine SSH Bridge · R=1.0 · absolute paths only
# Jesse Ray McMillen · Sikeston, Missouri

set -euo pipefail

ALPINE_HOST="${ALPINE_HOST:-192.168.1.50}"   # change once to real IP of Alpine node
ALPINE_USER="${ALPINE_USER:-root}"
KEY="/data/data/com.termux/files/home/black-locust-rmh/ssh/id_ed25519_blrmh"
KNOWN="/data/data/com.termux/files/home/black-locust-rmh/ssh/known_hosts"
LEDGER="/data/data/com.termux/files/home/black-locust-rmh/ledger/eta.json"
BRIDGE="/sdcard/openroot/context_bridge/lowest_node.json"

mkdir -p "$(dirname "\( KEY")" " \)(dirname "$LEDGER")"

if [ ! -f "$KEY" ]; then
  ssh-keygen -t ed25519 -f "\( KEY" -N "" -C "black-locust-rmh@ \)(hostname)-$(date -u +%Y%m%d)"
  echo "NEW KEY GENERATED → $KEY"
  echo "Copy public key to Alpine:"
  echo "  cat ${KEY}.pub"
  echo "  Then on Alpine: mkdir -p /root/.ssh && cat >> /root/.ssh/authorized_keys"
fi

# Strict host key + identity
SSH_OPTS="-i $KEY -o UserKnownHostsFile=$KNOWN -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8"

echo "=== Testing Alpine reachability ==="
if ssh \( SSH_OPTS " \){ALPINE_USER}@${ALPINE_HOST}" "echo ALPINE_ALIVE && uname -a && cat /etc/alpine-release"; then
  echo "SSH BRIDGE LIVE"
else
  echo "SSH FAILED — check ALPINE_HOST=$ALPINE_HOST and that sshd is running on Alpine"
  exit 1
fi

# Push minimal measured-η ledger skeleton if missing
ssh \( SSH_OPTS " \){ALPINE_USER}@${ALPINE_HOST}" "mkdir -p /root/black-locust-rmh/ledger"
if ! ssh \( SSH_OPTS " \){ALPINE_USER}@${ALPINE_HOST}" "test -f /root/black-locust-rmh/ledger/eta.json"; then
  cat > /tmp/eta_init.json << 'INNER'
{
  "node": "black-locust-rmh",
  "R": 1.0,
  "η": null,
  "measured_at": null,
  "useful_joules": null,
  "human_joules": null,
  "source": "Standing Wave Axiom · first physical measurement pending",
  "next": "instrument ΔT / airflow / shaft work"
}
INNER
  scp \( SSH_OPTS /tmp/eta_init.json " \){ALPINE_USER}@${ALPINE_HOST}:/root/black-locust-rmh/ledger/eta.json"
  echo "Initialized remote eta.json"
fi

# Lock local state
python3 -c "
import json, hashlib, pathlib
from datetime import datetime, timezone
BRIDGE = pathlib.Path('/sdcard/openroot/context_bridge')
now = datetime.now(timezone.utc).isoformat()
stmt = 'black-locust-rmh Alpine SSH bridge live · key at $KEY · remote ledger ready · R=1.0 · first measured η next'
data = {
  'node_id': 'LOWEST_NODE_v1',
  'statement': stmt,
  'recorded_at': now,
  'sha256': hashlib.sha256(stmt.encode()).hexdigest(),
  'R': 1.0,
  'next_physical': 'instrument black-locust-rmh thermal cascade + write measured η'
}
(BRIDGE / 'lowest_node.json').write_text(json.dumps(data, indent=2))
print(stmt)
"

echo "BRIDGE COMPLETE"
echo "KEY          → $KEY"
echo "PUBLIC       → ${KEY}.pub"
echo "REMOTE LEDGER→ \( {ALPINE_USER}@ \){ALPINE_HOST}:/root/black-locust-rmh/ledger/eta.json"
