{
  pkgs,
  lib,
  flakeDirectory,
  ...
}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };
  
  programs.fish.enable = true;
  # network
  hardware.opengl = {
    extraPackages = with pkgs; [
      mesa
    ];
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  networking = {
    hostName = "iso";
  };

  users.extraUsers.root.password = "nixos";

  environment.systemPackages = with pkgs; [
    git
    gum
    (
      writeShellScriptBin "rescue" ''
        #!/usr/bin/env bash
        set -euo pipefail

        gum "device name"

        sudo mkdir -p /mnt/{dev,proc,sys,boot}
        sudo mount -o bind /dev /mnt/dev
        sudo mount -o bind /proc /mnt/proc
        sudo mount -o bind /sys /mnt/sys
        sudo chroot /mnt /nix/var/nix/profiles/system/activate
        sudo chroot /mnt /run/current-system/sw/bin/bash

        sudo mount /dev/vda1 /mnt/boot
        sudo cryptsetup open /dev/vda3 cryptroot
        sudo mount /dev/mapper/cryptroot /mnt/

        sudo nixos-enter
      ''
    )
    (
      writeShellScriptBin "nix_installer"
      ''
        #!/usr/bin/env bash
        set -euo pipefail
        gsettings set org.gnome.desktop.session idle-delay 0
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        if [ ! -d "${flakeDirectory}/.git" ]; then
        	git clone --recurse-submodules git@gitlab.com:percygt/nix-dots.git "${flakeDirectory}"
        fi

        TARGET_HOST=$(ls -1 ${flakeDirectory}/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v iso | gum choose)

        if [ ! -e "${flakeDirectory}/profiles/$TARGET_HOST/disks.nix" ]; then
        	echo "ERROR! $(basename "$0") could not find the required ${flakeDirectory}/hosts/$TARGET_HOST/disks.nix"
        	exit 1
        fi

        gum confirm  --default=false \
        "🔥 🔥 🔥 WARNING!!!! This will ERASE ALL DATA on the disk $TARGET_HOST. Are you sure you want to continue?"

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
        --extra-experimental-features "nix-command flakes" \
        --no-write-lock-file \
        -- \
        --mode zap_create_mount \
        "${flakeDirectory}/profiles/$TARGET_HOST/disks.nix"

        #echo "Creating blank volume"
        #sudo btrfs subvolume snapshot -r /mnt/ /mnt/root-blank

        sudo nixos-install --flake "${flakeDirectory}#$TARGET_HOST"
      ''
    )
  ];
}
