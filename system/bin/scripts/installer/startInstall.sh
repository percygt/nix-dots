#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST=$1
TARGET_USER=$2

dots_dir="$HOME/nix-dots"

[ -d /mnt/persist/system/keys ] || sudo mkdir -p /mnt/persist/system/keys
[ -d /mnt/persist/home/"$TARGET_USER"/keys ] || sudo mkdir -p /mnt/persist/home/"$TARGET_USER"/keys

sudo cp /tmp/system-sops.keyfile /mnt/persist/system/keys
[[ -f /tmp/data.keyfile ]] && sudo cp /tmp/data.keyfile /mnt/persist/system/keys

sudo cp /tmp/home-sops.keyfile /mnt/persist/home/"$TARGET_USER"/keys
sudo chown -R 1000:users /mnt/persist/home/"$TARGET_USER"/keys
sudo chmod -R 700 /mnt/persist/home/"$TARGET_USER"/keys

sudo chmod -R 400 /mnt/persist/system/keys/system-sops.keyfile
sudo chmod -R 400 /mnt/persist/system/keys/data.keyfile
sudo chmod -R 600 /mnt/persist/home/"$TARGET_USER"/keys/home-sops.keyfile

sudo systemd-machine-id-setup --root=/mnt/persist/system

sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
