#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y live-build xorriso syslinux-common squashfs-tools debootstrap ca-certificates
lb clean || true
lb config
sudo lb build
