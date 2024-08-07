#!/usr/bin/env bash
set -euo pipefail

[ -d /mnt/persist/system/keys ] || sudo mkdir -p /mnt/persist/system/keys
[ -d /mnt/persist/home/"$TARGET_USER"/keys ] || sudo mkdir -p /mnt/persist/home/"$TARGET_USER"/keys

sudo cp /tmp/system-sops.keyfile /mnt/persist/system/keys
sudo chmod -R 400 /mnt/persist/system/keys/system-sops.keyfile

[[ -f /tmp/data.keyfile ]] && sudo cp /tmp/data.keyfile /mnt/persist/system/keys
sudo chmod -R 400 /mnt/persist/system/keys/data.keyfile

sudo chown -R 1000:users /mnt/persist/home/"$TARGET_USER"
cp /tmp/home-sops.keyfile /mnt/persist/home/"$TARGET_USER"/keys
cp "$HOME/usb/.k/pgp/dev/public.asc" /mnt/persist/home/"$TARGET_USER"/keys

chmod -R 700 /mnt/persist/home/"$TARGET_USER"/keys
chmod -R 600 /mnt/persist/home/"$TARGET_USER"/keys/home-sops.keyfile
chmod -R 600 /mnt/persist/home/"$TARGET_USER"/keys/public.asc

sudo nixos-install --flake "$DOTS_DIR#$TARGET_HOST" --no-root-passwd
