{
  lib,
  config,
  pkgs,
  ...
}:
{
  options._base = {
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
      default.package = lib.mkOption {
        description = "Default terminal package";
        type = lib.types.package;
        default = config._base.terminal.foot.package;
      };
      foot.package = lib.mkOption {
        description = "Foot terminal package";
        type = lib.types.package;
        default = pkgs.foot;
      };
      tilix.package = lib.mkOption {
        description = "Tilix terminal package";
        type = lib.types.package;
        default = pkgs.tilix;
      };
    };
    shell = {
      default.package = lib.mkOption {
        description = "Default shell package";
        type = lib.types.package;
        default = config._base.shell.fish.package;
      };
      fish.package = lib.mkOption {
        description = "Fish shell package";
        type = lib.types.package;
        default = pkgs.fish;
      };
      nushell.package = lib.mkOption {
        description = "Nushell shell package";
        type = lib.types.package;
        default = pkgs.nushell;
      };
      bash.package = lib.mkOption {
        description = "Bash shell package";
        type = lib.types.package;
        default = pkgs.bash;
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
            s = config._base.security;
            d = config._base.dev;
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
            s = config._base.security;
          in
          with pkgs;
          [
            s.keepass.package
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
          ++ config._base.system.envPackages;
      };
    };
  };
}
