{
  pkgs,
  lib,
  inputs,
  flakeDirectory,
  ...
}: {
  imports = [
    ./bin
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  environment.systemPackages = with pkgs; [
    gum
    git
    rsync
    age
    sops
    yq-go
    (
      writeShellScriptBin "blast_off"
      ''
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        gum confirm  --default=true \
          "Confirm that you have mounted your drive for credential setup."

        set_credentials

        clone_repos

        dots_dir=${flakeDirectory};

        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v "iso" | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        set_secrets $TARGET_HOST

        set_disks $TARGET_HOST

        install_nixos $TARGET_HOST

        post_install $TARGET_HOST
      ''
    )
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services = {
    qemuGuest.enable = true;
    udisks2.enable = true;
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

  isoImage.appendToMenuLabel = " live";
}
