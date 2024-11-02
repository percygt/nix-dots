#!/usr/bin/env bash
set -euo pipefail
gum confirm --default=true \
	"WARNING!!!! This will ERASE ALL DATA on the disks $TARGET_HOST. Are you sure you want to continue?"

echo "Partitioning Disks"
sudo nix run github:nix-community/disko \
	--extra-experimental-features "nix-command flakes" \
	--no-write-lock-file \
	-- \
	--mode zap_create_mount \
	"$DOTS_DIR/profiles/$TARGET_HOST/disks.nix"
