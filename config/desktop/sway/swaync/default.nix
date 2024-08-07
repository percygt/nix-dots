{ pkgs, config, ... }:
let
  inherit (config._general) flakeDirectory;
  swayncPkg = pkgs.swaynotificationcenter;
  moduleSwaync = "${flakeDirectory}/config/desktop/sway/swaync";
  c = config.modules.theme.colors.withHashtag;
  f = config.modules.fonts.interface;
  i = config.modules.fonts.icon;
in
{
  home.packages = [
    swayncPkg
    pkgs.at-spi2-core
  ];

  xdg.configFile = {
    "swaync/config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/config.json";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 .swaync-wrapped || true
      '';
    };
    "swaync/style.css" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/style.css";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 .swaync-wrapped || true
      '';
    };
    "swaync/configSchema.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/configSchema.json";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 .swaync-wrapped || true
      '';
    };
    "swaync/nix.css".text =
      # css
      ''
        @define-color bg0 ${c.base00};
        @define-color bg1 ${c.base01};
        @define-color bg2 ${c.base02};
        @define-color gr0 ${c.base03};
        @define-color gr1 ${c.base04};

        @define-color bg ${c.base00};
        @define-color bg-lighter ${c.base11};
        @define-color bg-darker ${c.base12};
        @define-color bg-alt ${c.base01};
        @define-color bg-hover-alt ${c.base02};
        @define-color grey ${c.base03};
        @define-color grey-alt ${c.base04};
        @define-color border ${c.base03};
        @define-color text-dark ${c.base01};
        @define-color text-light ${c.base05};
        @define-color green ${c.base0B};
        @define-color blue ${c.base0D};
        @define-color red ${c.base08};
        @define-color purple ${c.base0E};
        @define-color orange ${c.base0F};
        @define-color transparent rgba(0,0,0,0);
        @define-color bg-hover rgba(255, 255, 255, 0.1);
        @define-color bg-focus rgba(255, 255, 255, 0.1);
        @define-color bg-close rgba(255, 255, 255, 0.1);
        @define-color bg-close-hover rgba(255, 255, 255, 0.15);

        * {
          font-family: '${f.name}, ${i.name}';
          font-size: ${toString f.size}px;
        }
      '';
  };

  systemd.user.services.swaync = {
    Unit = {
      Description = "Swaync notification daemon";
      Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${swayncPkg}/bin/swaync";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
