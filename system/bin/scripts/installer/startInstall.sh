#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST=$1
TARGET_USER=$2

dots_dir="$HOME/nix-dots"

[ -d /mnt/var/keys ] || sudo mkdir -p /mnt/var/keys
[ -d /mnt/persist/system/var/keys ] || sudo mkdir -p /mnt/persist/system/var/keys

if [[ -f /tmp/data.keyfile ]]; then
	sudo cp /tmp/data.keyfile /mnt/var/keys
	sudo cp /tmp/data.keyfile /mnt/persist/system/var/keys
	# sudo chmod 400 "/mnt/var/keys/data.keyfile"
fi

sudo cp /tmp/system-sops.keyfile /mnt/var/keys
sudo cp /tmp/system-sops.keyfile /mnt/persist/system/var/keys
# sudo chmod -R 400 /mnt/var/keys/*-sops.keyfile

[ -d /mnt/home/"$TARGET_USER"/.var/keys ] || sudo mkdir -p /mnt/home/"$TARGET_USER"/.var/keys
[ -d /mnt/persist/home/.var/keys ] || sudo mkdir -p /mnt/persist/home/.var/keys
sudo cp /tmp/home-sops.keyfile /mnt/home/"$TARGET_USER"/.var/keys
sudo cp /tmp/home-sops.keyfile /mnt/persist/home/.var/keys
sudo chown -R 1000:users /mnt/home/"$TARGET_USER"/.var/keys
sudo chmod -R 700 /mnt/home/"$TARGET_USER"/.var/keys
# sudo chmod 400 "/mnt/home/$TARGET_USER/.var/keys/home-sops.keyfile"

sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
