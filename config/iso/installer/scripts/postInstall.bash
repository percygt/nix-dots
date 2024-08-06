set -euo pipefail
TARGET_HOST=$1
TARGET_USER=$2
LUKS=$3
DOTS="$HOME/nix-dots"
SECRETS="$HOME/sikreto"

sudo chown -R 1000:users /mnt/home/"$TARGET_USER"/data
sudo chown -R 1000:users /mnt/home/"$TARGET_USER"/windows

mkdir -p /mnt/home/"$TARGET_USER"/data/nix-dots
mkdir -p /mnt/home/"$TARGET_USER"/data/sikreto

rsync -a --delete "$DOTS" /mnt/home/"$TARGET_USER"/data
rsync -a --delete "$SECRETS" /mnt/home/"$TARGET_USER"/data

[ -d "$HOME/usb/.k/sops/$TARGET_HOST" ] || mkdir -p "$HOME/usb/.k/sops/$TARGET_HOST"
cp -rf /tmp/*.keyfile "$HOME/usb/.k/sops/$TARGET_HOST/"

findmnt /home/nixos/usb >/dev/null && sudo udisksctl unmount -b "$LUKS"
sudo cryptsetup luksClose "$LUKS"
