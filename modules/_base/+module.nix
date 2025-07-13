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
      type = lib.types.str;
      default = "${homeDirectory}/nix-dots";
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
      defaultCmd = lib.mkOption {
        description = "Default terminal command";
        type = lib.types.str;
        default = config.modules.terminal.foot.cmd;
      };
    };
    shell = {
      defaultPackage = lib.mkOption {
        description = "Default shell package";
        type = lib.types.package;
        default = pkgs.fish;
      };
    };
    security = {
      borgmatic = {
        mountUuid = lib.mkOption {
          description = "Backup mount uuid";
          type = lib.types.str;
          default = "";
        };
        usbId = lib.mkOption {
          description = "The bus and device id of the usb device e.g. 2-2 acquired from lsusb command 'Bus 002 Device 002'";
          type = lib.types.str;
          default = "";
        };
        mountPath = lib.mkOption {
          description = "Backup mount path";
          default = "";
          type = lib.types.str;
        };
      };
      gpg = {
        signingKey = lib.mkOption {
          description = "Gpg signing key";
          default = "";
          type = lib.types.str;
        };
      };
    };
    dataDirectory = lib.mkOption {
      description = "Home directory";
      default = "";
      type = lib.types.str;
    };
    secretsDirectory = lib.mkOption {
      description = "Home directory";
      default = "";
      type = lib.types.str;
    };
    syncthingDirectory = lib.mkOption {
      description = "Home directory";
      default = "";
      type = lib.types.str;
    };
    orgDirectory = lib.mkOption {
      description = "Org directory";
      default = "";
      type = lib.types.str;
    };
    windowsDirectory = lib.mkOption {
      description = "Windows directory";
      default = "";
      type = lib.types.str;
    };
    backupDirectory = lib.mkOption {
      description = "Backup mount path";
      default = "";
      type = lib.types.str;
    };
    network = {
      syncthing = {
        devices.phone.id = lib.mkOption {
          description = "Phone ID";
          default = "";
          type = lib.types.str;
        };
        guiAddress = lib.mkOption {
          description = "Gui Address";
          default = "";
          type = lib.types.str;
        };
      };
      wifi = lib.mkOption {
        description = "Wifi home";
        default = "";
        type = lib.types.str;
      };
      wireguard = {
        name = lib.mkOption {
          description = "Name";
          default = "nixos";
          type = lib.types.str;
        };
        publicKey = lib.mkOption {
          description = "Public Key";
          default = "";
          type = lib.types.str;
        };
        address = lib.mkOption {
          description = "IP address";
          default = "";
          type = lib.types.str;
        };
        dnsIp = lib.mkOption {
          description = "DNS IP";
          default = "";
          type = lib.types.str;
        };
        endpointIp = lib.mkOption {
          description = "Endpoint IP";
          default = "";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Endpoint Port";
          default = 8888;
          type = lib.types.port;
        };
      };
    };

    systemInstall = {
      targetUser = lib.mkOption {
        description = "targetUser";
        default = username;
        type = lib.types.str;
      };
      mountDevice = lib.mkOption {
        description = "Mount device";
        default = "";
        type = lib.types.str;
      };
      luksDevice = lib.mkOption {
        description = "Luks device";
        default = "";
        type = lib.types.str;
      };
    };
    localPrinter = lib.mkOption {
      description = "Keepass database";
      type = lib.types.attrs;
      default = { };
    };

    system = {
      envPackages = lib.mkOption {
        description = "Environment packages";
        type = with lib.types; listOf package;
        default =
          let
            inherit (cfg)
              shell
              ;
          in
          with pkgs;
          [
            config.nix.package.out
            shell.defaultPackage
            config.modules.security.gpg.package
            config.modules.security.ssh.package
            config.modules.dev.git.package
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
