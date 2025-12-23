{
  lib,
  config,
  pkgs,
  homeDirectory,
  username,
  host,
  ...
}:
let
  cfg = config._global;
  inherit (lib) mkOption types;
in
{
  options._global = {
    flakeDirectory = mkOption {
      description = "Flake directory";
      type = types.str;
      default = "${homeDirectory}/nix-dots";
    };
    dataDirectory = mkOption {
      description = "Home directory";
      default = "";
      type = types.str;
    };
    secretsDirectory = mkOption {
      description = "Home directory";
      default = "";
      type = types.str;
    };
    syncthingDirectory = mkOption {
      description = "Home directory";
      default = "";
      type = types.str;
    };
    orgDirectory = mkOption {
      description = "Org directory";
      default = "";
      type = types.str;
    };
    windowsDirectory = mkOption {
      description = "Windows directory";
      default = "";
      type = types.str;
    };
    backupDirectory = mkOption {
      description = "Backup mount path";
      default = "";
      type = types.str;
    };
    xdg = {
      userDirs = {
        download = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory + "/downloads";
          description = "The Downloads directory.";
        };
        music = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory + "/music";
          description = "The Music directory.";
        };
        pictures = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory + "/pictures";
          description = "The Pictures directory.";
        };
        publicShare = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory + "/shared";
          description = "The Public share directory.";
        };
        videos = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory;
          description = "The Videos directory.";
        };
        desktop = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory;
          description = "The Desktop directory.";
        };
        documents = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory;
          description = "The Documents directory.";
        };
        templates = mkOption {
          type = with types; nullOr (coercedTo path toString str);
          default = homeDirectory;
          description = "The Templates directory.";
        };
        extraConfig = mkOption {
          type = with types; attrsOf (coercedTo path toString str);
          default = {
            XDG_SCREENSHOTS_DIR = cfg.xdg.userDirs.pictures + "/screenshots";
          };
          description = "Other user directories.";
        };
      };
      configHome = mkOption {
        description = ''
          Absolute path to directory holding application configurations.
        '';
        default = homeDirectory + "/.config";
        type = types.str;
      };
      dataHome = mkOption {
        description = ''
          Absolute path to directory holding application data.
        '';
        default = homeDirectory + "/.local/share";
        type = types.str;
      };
      cacheHome = mkOption {
        description = ''
          Absolute path to directory holding application caches.
        '';
        default = homeDirectory + "/.local/cache";
        type = types.str;
      };
      stateHome = mkOption {
        description = ''
          Absolute path to directory holding application states.
        '';
        default = homeDirectory + "/.local/state";
        type = types.str;
      };
    };
    textEditor = {
      nvim = {
        "system.lua" = mkOption {
          description = "System Configs";
          default =
            # lua
            ''
              return {
                username = "${username}",
                host = "${host}",
                homeDirectory = "${homeDirectory}",
                flakeDirectory = "${cfg.flakeDirectory}",
              }
            '';
          type = types.lines;
        };
      };
      emacs = {
        "system.el" = mkOption {
          description = "System Configs";
          default =
            # lisp
            ''
              ;;; system.el --- System settings -*- lexical-binding: t -*-
              ;;; Commentary:
              ;;; Code:
              (defvar flakeDirectory
                "${config._global.flakeDirectory}"
                "Flake directory.")
              (provide 'system)
              ;;; system.el ends here
            '';
          type = types.lines;
        };
      };
    };
    terminal = {
      defaultPackage = mkOption {
        description = "Default terminal package";
        type = types.package;
        default = config.modules.terminal.foot.package;
      };
      defaultCmd = mkOption {
        description = "Default terminal command";
        type = types.str;
        default = config.modules.terminal.foot.cmd;
      };
    };
    shell = {
      defaultPackage = mkOption {
        description = "Default shell package";
        type = types.package;
        default = pkgs.nushell;
      };
    };
    security = {
      borgmatic = {
        mountUuid = mkOption {
          description = "Backup mount uuid";
          type = types.str;
          default = "";
        };
        usbId = mkOption {
          description = "The bus and device id of the usb device e.g. 2-2 acquired from lsusb command 'Bus 002 Device 002'";
          type = types.str;
          default = "";
        };
        mountPath = mkOption {
          description = "Backup mount path";
          default = "";
          type = types.str;
        };
      };
      gpg = {
        signingKey = mkOption {
          description = "Gpg signing key";
          default = "";
          type = types.str;
        };
      };
    };
    network = {
      syncthing = {
        devices.phone.id = mkOption {
          description = "Phone ID";
          default = "";
          type = types.str;
        };
        guiAddress = mkOption {
          description = "Gui Address";
          default = "";
          type = types.str;
        };
      };
      wifi = mkOption {
        description = "Wifi home";
        default = "";
        type = types.str;
      };
      wireguard = {
        name = mkOption {
          description = "Name";
          default = "nixos";
          type = types.str;
        };
        publicKey = mkOption {
          description = "Public Key";
          default = "";
          type = types.str;
        };
        address = mkOption {
          description = "IP address";
          default = "";
          type = types.str;
        };
        dnsIp = mkOption {
          description = "DNS IP";
          default = "";
          type = types.str;
        };
        endpointIp = mkOption {
          description = "Endpoint IP";
          default = "";
          type = types.str;
        };
        port = mkOption {
          description = "Endpoint Port";
          default = 8888;
          type = types.port;
        };
      };
    };

    systemInstall = {
      targetUser = mkOption {
        description = "targetUser";
        default = username;
        type = types.str;
      };
      mountDevice = mkOption {
        description = "Mount device";
        default = "";
        type = types.str;
      };
      luksDevice = mkOption {
        description = "Luks device";
        default = "";
        type = types.str;
      };
    };
    localPrinter = mkOption {
      description = "Local printer";
      type = types.attrs;
      default = { };
    };
    system = {
      envVars = mkOption {
        description = "Environment variables";
        type = types.attrs;
        default =
          let
            inherit (config.modules.themes)
              cursorTheme
              iconTheme
              gtkTheme
              ;
          in
          {
            FLAKE = cfg.flakeDirectory;
            MANPAGER = "nvim +Man!";
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            LC_CTYPE = "en_US.UTF-8";
            SDL_VIDEODRIVER = "wayland,x11";
            MOZ_ENABLE_WAYLAND = "1";
            NIXPKGS_ALLOW_UNFREE = "1";
            NIXOS_OZONE_WL = "1";
            GTK_IM_MODULE = "simple";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "0";
            GTK_THEME = gtkTheme.name;
            GTK_CURSOR = cursorTheme.name;
            XCURSOR_THEME = cursorTheme.name;
            XCURSOR_SIZE = "${toString cursorTheme.size}";
            GTK_ICON = iconTheme.name;
          };
      };
      envPackages = mkOption {
        description = "Environment packages";
        type = with types; listOf package;
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
            gawk
            gnugrep
            gnused
            nfs-utils
            iputils
            coreutils
            findutils
            pciutils
            usbutils
            util-linux
            nettools
            kmod
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
      corePackages = mkOption {
        description = "Core Packages";
        type = with types; listOf package;
        default =
          with pkgs;
          [
            wirelesstools
            ntfs3g
            exfat
            exfatprogs
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
            unzip
            gzip
            unrar-free
          ]
          ++ cfg.system.envPackages;
      };
    };
  };
}
