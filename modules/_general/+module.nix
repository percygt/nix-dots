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
        default = pkgs.swayfx-git;
      };
    };
    dev = {
      git.package = lib.mkOption {
        description = "Git package";
        type = lib.types.package;
        default = pkgs.git;
      };
    };
    terminal = {
      foot.package = lib.mkOption {
        description = "Foot terminal package";
        type = lib.types.package;
        default = pkgs.foot;
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
    system = {
      envPackages = lib.mkOption {
        description = "Environment packages";
        type = with lib.types; listOf package;
        default =
          let
            s = config._general.security;
            d = config._general.dev;
          in
          with pkgs;
          [
            config.programs.fish.package
            config.nix.package.out
            s.sops.package
            s.gpg.package
            s.ssh.package
            d.git.package
            nfs-utils
            iputils
            coreutils-full
            findutils
            pciutils
            usbutils
            util-linux
            acpi
            procps
            systemd
            nixos-rebuild
            gnugrep
            nix-output-monitor
            nvd
            su
            mpv
            libnotify
            gnutar
            gzip
            xz.bin
          ];
      };
      corePackages = lib.mkOption {
        description = "Core Packages";
        type = with lib.types; listOf package;
        default =
          let
            s = config._general.security;
          in
          with pkgs;
          [
            s.keepass.package
            just
            wirelesstools
            ntfs3g
            psmisc
            lsof
            age
            curl
            wget
            lshw
            file
            killall
            rsync
            tree
            traceroute
            cryptsetup
            procps
            unzip
            gzip
            unrar-free
          ]
          ++ config._general.system.envPackages;
      };
    };
  };
}
