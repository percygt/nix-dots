{
  pkgs,
  lib,
  flakeDirectory,
  profile,
  target_user,
  listImports,
  ...
}: let
  modules = [
    "core/console.nix"
  ];
in {
  imports = listImports ../../system modules;
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  # network
  hardware.opengl = {
    extraPackages = with pkgs; [
      mesa
    ];
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    extraOptions = "experimental-features = nix-command flakes";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
  networking = {
    hostName = profile;
  };
  programs.git.enable = true;
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host gitlab.com
        PreferredAuthentications publickey
        IdentityFile /etc/ssh/id_ed25519_glab
    '';
    knownHosts."gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
  };
  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
    appendToMenuLabel = " live";
    contents = [
      {
        source = ~/.ssh/id_ed25519_glab;
        target = "/id_ed25519_glab";
      }
    ];
  };
  environment.systemPackages = with pkgs; [
    rsync
    gum
    (
      writeShellScriptBin "nix_install"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        sleep 1

        if [ ! -d "${flakeDirectory}/.git" ]; then
          # Define source and destination directories
          source_dir="/iso/id_ed25519_glab"
          destination_dir="/etc/ssh/"
          if [ -e "$source_dir" ]; then
            # Copy .ssh directory to the destination directory
            sudo cp "$source_dir" "$destination_dir"
            sleep 3
            git clone --recurse-submodule git@gitlab.com:percygt/nix-dots.git
            sleep 2
            cd nix-dots
          else
            echo "Source directory $source_dir does not exist"
            exit 1
          fi
        fi

        TARGET_HOST=$(ls -1 ~/nix-dots/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${profile} | gum choose)

        if [ ! -e "$HOME/nix-dots/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $HOME/nix-dots/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi
        gum confirm  --default=false \
          "🔥 🔥 🔥 WARNING!!!! This will ERASE ALL DATA on the disks $TARGET_HOST. Are you sure you want to continue?"

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
          --extra-experimental-features "nix-command flakes" \
          --no-write-lock-file \
          -- \
          --mode zap_create_mount \
          "$HOME/nix-dots/profiles/$TARGET_HOST/disks.nix"

        sudo nixos-install --flake "$HOME/nix-dots#$TARGET_HOST"
        
        DIR=$( cd "$( dirname "''${BASH_SOURCE [0]}" )" && pwd )
        echo $DIR

        # Rsync my nix-config to the target install
        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$DIR/.." "/mnt/home/${target_user}/nix-dots"

        # If there is a keyfile for a data disks, put copy it to the root partition and
        # ensure the permissions are set appropriately.
        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp /tmp/data.keyfile /mnt/etc/data.keyfile
          sudo chmod 0400 /mnt/etc/data.keyfile
        fi
      ''
    )
  ];
}
