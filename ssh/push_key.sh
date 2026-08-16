#!/data/data/com.termux/files/usr/bin/bash
# Manual key push helper (run once after generating key)
KEY=/data/data/com.termux/files/home/black-locust-rmh/ssh/id_ed25519_blrmh
echo "=== PUBLIC KEY (paste into Alpine /root/.ssh/authorized_keys) ==="
cat "${KEY}.pub"
echo ""
echo "On Alpine execute:"
echo "  mkdir -p /root/.ssh"
echo "  chmod 700 /root/.ssh"
echo "  cat >> /root/.ssh/authorized_keys"
echo "  (paste the key above, then Ctrl-D)"
echo "  chmod 600 /root/.ssh/authorized_keys"
echo "  rc-update add sshd default"
echo "  service sshd start"
