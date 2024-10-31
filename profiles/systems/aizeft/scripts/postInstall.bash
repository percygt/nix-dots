#!/usr/bin/env bash
set -euo pipefail

sudo chown -R 1000:users /mnt"$DATA"
sudo chown -R 1000:users /mnt"$WINDOWS"

mkdir -p /mnt"$FLAKE"
mkdir -p /mnt"$SECRETS"

rsync -a --delete "$DOTS_DIR" /mnt"$DATA"
rsync -a --delete "$SEC_DIR" /mnt"$DATA"

[ -d "$HOME/usb/.k/sops/$TARGET_HOST" ] || mkdir -p "$HOME/usb/.k/sops/$TARGET_HOST"
cp -rf /tmp/*.keyfile "$HOME/usb/.k/sops/$TARGET_HOST/"

findmnt /home/nixos/usb >/dev/null && sudo udisksctl unmount -b "$LUKS_DEVICE"
sudo cryptsetup luksClose "$LUKS_DEVICE"
