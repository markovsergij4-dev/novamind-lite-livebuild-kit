#!/bin/bash
RAM_MB=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
if [ "$RAM_MB" -lt 4096 ]; then
  SESSION_CMD="/usr/bin/startxfce4"
else
  SESSION_CMD="/usr/bin/startplasma-x11"
fi
update-alternatives --set x-session-manager "$SESSION_CMD" >/dev/null 2>&1 || true
echo "$SESSION_CMD" > /home/user/.nml-session 2>/dev/null || true
chown user:user /home/user/.nml-session 2>/dev/null || true
