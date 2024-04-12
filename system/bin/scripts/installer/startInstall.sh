#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST=$1
TARGET_USER=$2

dots_dir="$HOME/nix-dots"

[ -d "/mnt/etc/nixos/keys" ] || sudo mkdir -p "/mnt/etc/nixos/keys"
if [[ -f "/tmp/data.keyfile" ]]; then
	sudo cp "/tmp/data.keyfile" "/mnt/etc/nixos/keys"
	sudo chmod 400 "/mnt/etc/nixos/keys/data.keyfile"
fi

sudo cp /tmp/system-sops.keyfile "/mnt/etc/nixos/keys/"
sudo chmod -R 400 /mnt/etc/nixos/keys/*-sops.keyfile

[ -d "/mnt/home/$TARGET_USER/.nixos" ] || sudo mkdir -p "/mnt/home/$TARGET_USER/.nixos/keys"
sudo chown -R 1000:users "/mnt/home/$TARGET_USER/.nixos"
sudo cp /tmp/home-sops.keyfile "/mnt/home/$TARGET_USER/.nixos/keys/"
sudo chown -R 1000:users "/mnt/home/$TARGET_USER/.nixos"
sudo chmod -R 700 "/mnt/home/$TARGET_USER/.nixos"
sudo chmod 400 "/mnt/home/$TARGET_USER/.nixos/keys/home-sops.keyfile"

sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
