#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST=$1
TARGET_USER=$2
LUKS=$3
DOTS="$HOME/nix-dots"
SECRETS="$HOME/sikreto"

mkdir -p /mnt/home/"$TARGET_USER"/.nixos/nix-dots
mkdir -p /mnt/home/"$TARGET_USER"/.nixos/sikreto
rsync -a --delete "$DOTS" /mnt/home/"$TARGET_USER"/.nixos
rsync -a --delete "$SECRETS" /mnt/home/"$TARGET_USER"/.nixos

[ -d "$HOME/usb/.k/sops/$TARGET_HOST" ] || mkdir -p "$HOME/usb/.k/sops/$TARGET_HOST"
cp -rf /tmp/*.keyfile "$HOME/usb/.k/sops/$TARGET_HOST/"

findmnt /home/nixos/usb >/dev/null && sudo udisksctl unmount -b "$LUKS"
sudo cryptsetup luksClose "$LUKS"
