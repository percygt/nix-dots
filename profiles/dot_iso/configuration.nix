{
  pkgs,
  lib,
  hostName,
  target_user,
  inputs,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

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

  isoImage = {
    appendToMenuLabel = " live";
    # copy self(flake directory) to /iso path of the dot installer
    # contents = [
    #   {
    #     source = self;
    #     target = "/nix-dots";
    #   }
    # ];
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

        dots_dir="$HOME/nix-dots";

        if [ ! -d "$dots_dir/.git" ]; then
        	git clone --depth 1 https://gitlab.com/percygt/nix-dots.git "$dots_dir"
        fi

        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${hostName} | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        if grep -q "data.keyfile" "$dots_dir/profiles/$TARGET_HOST/disks.nix"; then
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
          "$dots_dir/profiles/$TARGET_HOST/disks.nix"

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd

        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/"

        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp /tmp/data.keyfile /mnt/etc/
          sudo chmod 0400 /mnt/etc/data.keyfile
        fi

        echo "Reboot now"
      ''
    )
  ];
}
