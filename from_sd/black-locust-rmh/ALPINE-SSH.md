# Black Locust RMH — Alpine SSH Bridge
Target: Alpine container via Termux/Shizuku
Port: 8022
Command sequence:
sshd -p 8022
# then from Kai9000: Settings → SSH → host alias black-locust
# push: rsync -avz -e "ssh -p 8022" . user@localhost:\~/black-locust-rmh/

## LIVE 2026-07-26T23:38:03-05:00
- sshd running on 8022
- key auth confirmed with id_ed25519
- local test: SSH_BRIDGE_OK
