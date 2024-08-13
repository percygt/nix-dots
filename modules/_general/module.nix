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
        description = "Sway package";
        type = lib.types.package;
        default = pkgs.swayfx;
      };
    };
    defaultShell = lib.mkOption {
      description = "Default shell";
      type = lib.types.str;
      default = "fish";
    };
    dev = {
      git.package = lib.mkOption {
        description = "Git package";
        type = lib.types.package;
        default = pkgs.git;
      };
    };
    security = {
      gpg.package = lib.mkOption {
        description = "Gpg package";
        type = lib.types.package;
        default = pkgs.gnupg;
      };
      ssh.package = lib.mkOption {
        description = "Ssh package";
        type = lib.types.package;
        default = pkgs.openssh;
      };
      sops.package = lib.mkOption {
        description = "Sops package";
        type = lib.types.package;
        default = pkgs.sops;
      };
      keepass.package = lib.mkOption {
        description = "Keepass package";
        type = lib.types.package;
        default = pkgs.keepassxc;
      };
      borgmatic.package = lib.mkOption {
        description = "Borgmatic package";
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
          d = config._general.dev;
        in
        with pkgs;
        [
          config.nix.package.out
          s.sops.package
          s.keepass.package
          s.gpg.package
          s.ssh.package
          d.git.package
          coreutils
          systemd
          mpv
          libnotify
          dconf
          direnv
          home-manager
          curl
          wget
          lshw
          nixos-rebuild
          sudo

          file
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

          gnutar
          xz.bin
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
      type = lib.types.str;
      default = "/home/${config._general.username}";
    };
    stateVersion = lib.mkOption {
      description = "State version";
      type = lib.types.str;
      default = "23.05";
    };
  };
}
