{
  lib,
  config,
  pkgs,
  ...
}:
{
  options._general = {
    desktop = {
      sway.package = lib.mkOption {
        description = "Sway pakage";
        type = lib.types.package;
        default = pkgs.swayfx;
      };
    };
    defaultShell = lib.mkOption {
      description = "Default shell";
      type = lib.types.str;
      default = "fish";
    };
    security = {
      gpg.package = lib.mkOption {
        description = "Gpg pakage";
        type = lib.types.package;
        default = pkgs.gnupg;
      };
      ssh.package = lib.mkOption {
        description = "Ssh pakage";
        type = lib.types.package;
        default = pkgs.openssh;
      };
      sops.package = lib.mkOption {
        description = "Sops pakage";
        type = lib.types.package;
        default = pkgs.sops;
      };
      keepass.package = lib.mkOption {
        description = "Keepass pakage";
        type = lib.types.package;
        default = pkgs.keepassxc;
      };
      borgmatic.package = lib.mkOption {
        description = "Borgmatic pakage";
        type = lib.types.package;
        default = pkgs.borgmatic;
      };
    };
    corePackages = lib.mkOption {
      description = "Default shell";
      type = with lib.types; listOf package;
      default =
        let
          s = config._general.security;
        in
        with pkgs;
        [
          s.sops.package
          s.keepass.package
          s.gpg.package
          s.ssh.package
          systemd
          mpv
          libnotify
          bash
          dconf
          direnv
          git
          gnutar
          home-manager
          nh
          curl
          wget
          lshw
          coreutils-full
          nixos-rebuild
          gnutar
          gzip
          xz.bin
          sudo

          file
          git
          killall
          nfs-utils
          ntfs3g
          pciutils
          rsync
          tree
          traceroute
          cryptsetup
          procps
          usbutils

          unzip
          gzip
          unrar-free
        ];
    };

    username = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = "percygt";
    };
    homeDirectory = lib.mkOption {
      description = "Home directory";
      default = "/home/${config._general.username}";
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      description = "State version";
      default = "23.05";
      type = lib.types.str;
    };
  };
}
