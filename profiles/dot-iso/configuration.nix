{
  pkgs,
  lib,
  hostName,
  target_user,
  inputs,
  flakeDirectory,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ./bin
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

  environment = {
    shellAliases = {
      ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  isoImage.appendToMenuLabel = " live";

  environment.systemPackages = with pkgs; [
    gum
    git
    rsync
    age
    sops
    yq-go
    home-manager
    (
      writeShellScriptBin "disks"
      ''
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        if ! findmnt /home/nixos/usb >/dev/null; then
          setcredentials
        fi

        clonerepos

        dots_dir="$HOME/nix-dots";
        sec_dir="$HOME/sikreto";

        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${hostName} | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        echo "Setting up secrets and keys..."

        if grep -q "/tmp/data.keyfile" "$dots_dir/profiles/$TARGET_HOST/disks.nix"; then
          echo -n "$(head -c32 /dev/random | base64)" > "/tmp/data.keyfile"
        fi

        if [ ! -e "$HOME/secrets_updated" ]; then
          setagekey $TARGET_HOST
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

        [ -e "/mnt/etc/secrets" ] || sudo mkdir -p "/mnt/etc/secrets"

        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp "/tmp/data.keyfile" "/mnt/etc/secrets"
          sudo chmod 0400 "/mnt/etc/secrets/data.keyfile"
        fi

        sudo cp -r /tmp/*-sops.keyfile "/mnt/etc/secrets/"
        sudo chmod -R 0400 /mnt/etc/secrets/*-sops.keyfile

        [ -d "$HOME/usb/.k/sops/$TARGET_HOST" ] || mkdir -p "$HOME/usb/.k/sops/$TARGET_HOST"
        cp -rf /tmp/*.keyfile "$HOME/usb/.k/sops/$TARGET_HOST/"

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd

        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/"

        findmnt /home/nixos/usb >/dev/null || sudo udisksctl -b /dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5
        sudo cryptsetup luksClose /dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9
      ''
    )
    (
      writeShellScriptBin "nixins"
      ''
        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${hostName} | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd

        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/"

        findmnt /home/nixos/usb >/dev/null || sudo udisksctl -b /dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5
        sudo cryptsetup luksClose /dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9
      ''
    )
  ];
}
