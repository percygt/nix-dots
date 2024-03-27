{
  pkgs,
  lib,
  self,
  hostName,
  target_user,
  listSystemImports,
  outputs,
  inputs,
  config,
  ...
}: let
  modules = [
    "common/console.nix"
    "common/packages.nix"
    "common/locale.nix"
    "extra/fonts.nix"
  ];
in {
  imports =
    listSystemImports modules
    ++ [
      inputs.home-manager.nixosModules.default
      {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

  networking = {
    inherit hostName;
  };

  home-manager.users.nixos = import ./home.nix {inherit outputs config lib;};

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
    overlays = builtins.attrValues outputs.overlays;
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

  programs.git.enable = true;

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
    appendToMenuLabel = " live";
    # copy self(flake directory) to /iso path of the dot installer
    contents = [
      {
        source = self;
        target = "/nix-dots";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    gum
    rsync
    (
      writeShellScriptBin "inst"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        TARGET_HOST=$(ls -1 /iso/nix-dots/profiles/*/configuration.nix | cut -d'/' -f5 | grep -v ${hostName} | gum choose)

        if [ ! -e "/iso/nix-dots/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required /iso/nix-dots/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        if grep -q "data.keyfile" "/iso/nix-dots/profiles/$TARGET_HOST/disks.nix"; then
          echo -n "$(head -c32 /dev/random | base64)" > /tmp/data.keyfile
        fi

        gum confirm  --default=true \
          "WARNING!!!! This will ERASE ALL DATA on the disks $TARGET_HOST. Are you sure you want to continue?"

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
          --extra-experimental-features "nix-command flakes" \
          --no-write-lock-file \
          -- \
          --mode zap_create_mount \
          "/iso/nix-dots/profiles/$TARGET_HOST/disks.nix"

        sudo nixos-install --flake "/iso/nix-dots#$TARGET_HOST" --no-root-passwd

        rsync -a "/iso/nix-dots" "/mnt/home/${target_user}/"

        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp /tmp/data.keyfile /mnt/etc/data.keyfile
          sudo chmod 0400 /mnt/etc/nixos/data.keyfile
        fi
      ''
    )
  ];
}
