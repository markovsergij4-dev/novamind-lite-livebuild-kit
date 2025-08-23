#!/usr/bin/env bash
set -euo pipefail
REQ_LABEL="NovaMind_Lite_OS"
if [[ $EUID -ne 0 ]]; then echo "Run as root"; exit 1; fi
BOOT_PART=$(readlink -f "/dev/disk/by-label/$REQ_LABEL" 2>/dev/null || true)
if [[ -z "$BOOT_PART" ]]; then echo "Label not found: $REQ_LABEL"; lsblk -o NAME,LABEL,SIZE,TYPE; exit 1; fi
DEV="/dev/$(lsblk -no pkname "$BOOT_PART")"
MAP=$(parted -sm "$DEV" unit MiB print free || true)
LARGEST_SIZE=-1; LARGEST_START=""; LARGEST_END=""
while IFS=: read -r num type rest; do
  [[ "$type" != "free" ]] && continue
  IFS=":" read -r _ _ START END SIZE _ _ _ <<<"$num:$type:$rest"
  START=${START%MiB}; END=${END%MiB}; SIZE=${SIZE%MiB}
  START=${START%.*}; END=${END%.*}; SIZE=${SIZE%.*}
  if [[ $SIZE -gt $LARGEST_SIZE ]] ; then LARGEST_SIZE=$SIZE; LARGEST_START=$START; LARGEST_END=$END; fi
done <<<"$MAP"
[[ $LARGEST_SIZE -ge 100 ]] || { echo "Not enough free space"; exit 1; }
parted -s "$DEV" mkpart persistence ext4 "${LARGEST_START}MiB" "${LARGEST_END}MiB"
NEW_PART=$(lsblk -nrpo NAME "$DEV" | tail -n1)
mkfs.ext4 -F -L persistence "$NEW_PART" >/dev/null
mkdir -p /mnt/persistence; mount "$NEW_PART" /mnt/persistence
echo "/ union" > /mnt/persistence/persistence.conf
sync; umount /mnt/persistence; rmdir /mnt/persistence || true
echo "Persistence ready on $NEW_PART"
