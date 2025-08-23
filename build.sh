#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y live-build xorriso syslinux-common squashfs-tools debootstrap ca-certificates parted
sudo rm -rf config/* cache/* chroot/* binary/* || true
sudo lb clean || true
sudo lb config --distribution bookworm   --mirror-bootstrap http://deb.debian.org/debian/   --mirror-binary    http://deb.debian.org/debian/   --mirror-chroot    http://deb.debian.org/debian/   --mirror-chroot-security http://security.debian.org/debian-security/   --mirror-binary-security http://security.debian.org/debian-security/
sudo lb build
