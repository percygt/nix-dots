{
  lib,
  config,
  pkgs,
  homeDirectory,
  username,
  profile,
  ...
}:
let
  cfg = config._base;
in
{
  options._base = {
    flakeDirectory = lib.mkOption {
      description = "Flake directory";
      default = "${homeDirectory}/nix-dots";
      type = lib.types.str;
    };
    dev = {
      git.package = lib.mkOption {
        description = "Git package";
        type = lib.types.package;
        default = pkgs.git;
      };
    };
    textEditor = {
      nvim = {
        "system.lua" = lib.mkOption {
          description = "System Configs";
          default =
            # lua
            ''
              return {
                username = "${username}",
                profile = "${profile}",
                homeDirectory = "${homeDirectory}",
                flakeDirectory = "${config._base.flakeDirectory}",
              }
            '';
          type = lib.types.lines;
        };
      };
      emacs = {
        "system.el" = lib.mkOption {
          description = "System Configs";
          default =
            # lisp
            ''
              ;;; system.el --- System settings -*- lexical-binding: t -*-
              ;;; Commentary:
              ;;; Code:
              (defvar flakeDirectory
                "${config._base.flakeDirectory}"
                "Flake directory.")
              (provide 'system)
              ;;; system.el ends here
            '';
          type = lib.types.lines;
        };
      };
    };
    terminal = {
      defaultPackage = lib.mkOption {
        description = "Default terminal package";
        type = lib.types.package;
        default = config.modules.terminal.foot.package;
      };
    };
    shell = {
      default.package = lib.mkOption {
        description = "Default shell package";
        type = lib.types.package;
        default = cfg.shell.fish.package;
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
            inherit (cfg)
              security
              shell
              dev
              ;
          in
          with pkgs;
          [
            config.nix.package.out
            shell.default.package
            shell.bash.package
            security.gpg.package
            security.ssh.package
            dev.git.package
            nh
            nfs-utils
            iputils
            coreutils
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
          with pkgs;
          [
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
          ++ cfg.system.envPackages;
      };
    };
  };
}
