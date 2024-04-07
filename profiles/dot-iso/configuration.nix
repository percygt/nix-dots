{
  pkgs,
  lib,
  hostName,
  target_user,
  inputs,
  self,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];
  security.sops.enable = true;

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
    contents = [
      {
        source = self;
        target = "/nix-dots";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    gum
    git
    rsync
    age
    sops
    yq-go
    home-manager
    (
      writeShellScriptBin "creds"
      ''
        set -euo pipefail
        if [ ! -e /dev/mapper/luksvol ]; then
          sudo cryptsetup luksOpen /dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5 luksvol
          sudo systemctl daemon-reload
          sleep 1
          mkdir "$HOME/usb"
          sudo mount /dev/mapper/luksvol "$HOME/usb"
          gpg --import "$HOME/usb/.k/pgp/dev/subkeys.gpg"
          sleep 1
          cp -f "$HOME/usb/credentials"  "$HOME/.config/git/"
        fi
      ''
    )
    (
      writeShellScriptBin "clones"
      ''
        set -euo pipefail
        dots_dir="$HOME/nix-dots";
        sec_dir="$HOME/sikreto";

        if [ ! -d "$dots_dir/.git" ]; then
        	git clone git@gitlab.com:percygt/nix-dots.git "$dots_dir"
        fi

        if [ ! -d "$sec_dir/.git" ]; then
        	git clone git@gitlab.com:percygt/sikreto.git "$sec_dir"
        fi

      ''
    )
    (
      writeShellScriptBin "nixins"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        dots_dir="$HOME/nix-dots";
        sec_dir="$HOME/sikreto";


        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${hostName} | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        echo "Setting up secrets and keys..."
        if grep -q "$TARGET_HOST.luks-data.keyfile" "$dots_dir/profiles/$TARGET_HOST/disks.nix"; then
          echo -n "$(head -c32 /dev/random | base64)" > "/tmp/$TARGET_HOST.luks-data.keyfile"
        fi

        [ -e "/tmp/$TARGET_HOST.keyfile" ] || age-keygen -o "/tmp/$TARGET_HOST.keyfile"


        pushd $sec_dir &> /dev/null;
        if [ $(git status --porcelain | wc -l) -eq "0" ] && [ ! -v AGE_PUBLIC_KEY ]; then
          SOPS_AGE_KEY_FILE="/tmp/$TARGET_HOST.keyfile"
          AGE_PUBLIC_KEY=$(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)")
          yq ".keys[.keys[] | select(anchor == \"$TARGET_HOST\") | path | .[-1]] = \"$AGE_PUBLIC_KEY\"" -i "$sec_dir/.sops.yaml"
          sops updatekeys secrets.enc.yaml
          git add .
          git commit -m "Install/reinstall $TARGET_HOST"
          git push origin main
        fi
        popd &> /dev/null;

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

        sudo cp "/tmp/$TARGET_HOST.keyfile" "/mnt/etc/secrets"
        sudo chmod 0400 "/mnt/etc/secrets/$TARGET_HOST.keyfile"

        if [[ -f "/tmp/$TARGET_HOST.luks-data.keyfile" ]]; then
          sudo cp "/tmp/$TARGET_HOST.luks-data.keyfile" "/mnt/etc/secrets"
          sudo chmod 0400 "/mnt/etc/secrets/$TARGET_HOST.luks-data.keyfile"
        fi

        [ -e "$HOME/usb/.k/sops" ] && sudo cp -f "/tmp/*.keyfile" "$HOME/usb/.k/sops/"

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd

        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/"

        sudo umount --all
      ''
    )
  ];
}
