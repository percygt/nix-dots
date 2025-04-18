{
  lib,
  config,
  pkgs,
  homeDirectory,
  ...
}:
let
  cfg = config._base;
  unsupported-gpu = config.modules.driver.nvidia.prime.enable;
in
{
  options._base = {
    flakeDirectory = lib.mkOption {
      description = "Flake directory";
      default = "${homeDirectory}/nix-dots";
      type = lib.types.str;
    };
    desktop = {
      sway = {
        command = lib.mkOption {
          description = "Sway package";
          type = lib.types.str;
          default = "sway${lib.optionalString unsupported-gpu " --unsupported-gpu"}";
        };
        package = lib.mkOption {
          description = "Sway package";
          type = lib.types.package;
          default = pkgs.swayfx;
        };
        finalPackage = lib.mkOption {
          description = "Sway package";
          type = lib.types.package;
          default = cfg.desktop.sway.package.override {
            swayfx-unwrapped = pkgs.swayfx-unwrapped.overrideAttrs (old: {
              postInstall =
                let
                  swaySession = ''
                    [Desktop Entry]
                    Name=Sway${lib.optionalString unsupported-gpu "Nvidia"}
                    Comment=An i3-compatible Wayland compositor
                    Exec=${cfg.desktop.sway.command}
                    Type=Application
                  '';
                in
                ''
                  [ ! -d $out/share/wayland-sessions ] && mkdir -p $out/share/wayland-sessions
                  echo "${swaySession}" > $out/share/wayland-sessions/sway.desktop
                '';
              providedSessions = [ "sway" ];
            });
          };
        };
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
        default = cfg.terminal.foot.package;
      };
      foot.package = lib.mkOption {
        description = "Foot terminal package";
        type = lib.types.package;
        default = pkgs.foot;
      };
      wezterm.package = lib.mkOption {
        description = "Wezterm terminal package";
        type = lib.types.package;
        default = pkgs.wezterm;
      };
      tilix.package = lib.mkOption {
        description = "Tilix terminal package";
        type = lib.types.package;
        default = pkgs.stable.tilix;
      };
      xfce4-terminal.package = lib.mkOption {
        description = "Xfce4-terminal terminal package";
        type = lib.types.package;
        default = pkgs.xfce.xfce4-terminal;
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
