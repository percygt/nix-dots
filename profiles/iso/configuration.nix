{
  pkgs,
  lib,
  flakeDirectory,
  profile,
  ...
}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
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
    extraConfig = ''
      Host gitlab.com
        PreferredAuthentications publickey
        IdentityFile /iso/key
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
        target = "/key";
      }
    ];
  };
  environment.systemPackages = with pkgs; [
    eza
    bat
    gum
    gnome.gnome-terminal
    (
      writeShellScriptBin "nix_install"
      ''
        #!/usr/bin/env bash
        set -euo pipefail
        gsettings set org.gnome.desktop.session idle-delay 0
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        sleep 1
        if [ ! -d "${flakeDirectory}/.git" ]; then
          git clone --recurse-submodule git@gitlab.com:percygt/nix-dots.git "${flakeDirectory}"
        fi

        TARGET_HOST=$(ls -1 ${flakeDirectory}/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v iso | gum choose)

        if [ ! -e "${flakeDirectory}/profiles/$TARGET_HOST/disk.nix" ]; then
        	echo "ERROR! $(basename "$0") could not find the required ${flakeDirectory}/profiles/$TARGET_HOST/disk.nix"
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
        "${flakeDirectory}/profiles/$TARGET_HOST/disk.nix"

        sudo nixos-install --flake "${flakeDirectory}'?submodules=1#'$TARGET_HOST"
      ''
    )
  ];
}
