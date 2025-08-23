#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID -ne 0 ]]; then echo "Run as root"; exit 1; fi
if [[ $# -ne 1 ]]; then echo "Usage: $0 /dev/sdX"; exit 1; fi
DEV="$1"; lsblk -o NAME,LABEL,SIZE,TYPE "$DEV"
MAP=$(parted -sm "$DEV" unit MiB print free | tr -s ' ' || true)
LARGEST_SIZE=-1; LARGEST_START=""; LARGEST_END=""
while IFS=: read -r num type rest; do
  if [[ "$type" == "free" ]]; then
    IFS=":" read -r _ _ START END SIZE _ _ _ <<<"$num:$type:$rest"
    START=${START%MiB}; END=${END%MiB}; SIZE=${SIZE%MiB}
    START=${START%.*}; END=${END%.*}; SIZE=${SIZE%.*}
    if [[ $SIZE -gt $LARGEST_SIZE ]]; then LARGEST_SIZE=$SIZE; LARGEST_START=$START; LARGEST_END=$END; fi
  fi
done <<<"$MAP"
if [[ $LARGEST_SIZE -lt 100 ]]; then echo "Not enough free space."; exit 1; fi
read -p "Create 'persistence' on $DEV? (yes/NO) " ans
[[ "${ans,,}" == "yes" ]] || { echo "Aborted."; exit 0; }
parted -s "$DEV" mkpart persistence ext4 "${LARGEST_START}MiB" "${LARGEST_END}MiB"
NEW_PART=$(lsblk -nrpo NAME "$DEV" | tail -n1)
mkfs.ext4 -F -L persistence "$NEW_PART" >/dev/null
mkdir -p /mnt/persistence; mount "$NEW_PART" /mnt/persistence
echo "/ union" > /mnt/persistence/persistence.conf
sync; umount /mnt/persistence; rmdir /mnt/persistence || true
echo "Persistence partition ready on $NEW_PART"
