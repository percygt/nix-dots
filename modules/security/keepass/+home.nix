{
  pkgs,
  lib,
  config,
  desktop,
  ...
}:
let
  g = config._base;
  kpdb = g.security.keepass.db;
in
{
  imports = [
    ./keepfzf.nix
  ];

  config = lib.mkIf config.modules.security.keepass.enable {
    modules.desktop.sway.floatingRules = [
      {
        command = ''resize set width 80ppt height 80ppt, move position center'';
        criterias = [ { app_id = "org.keepassxc.KeePassXC"; } ];
      }
    ];
    home = {
      packages =
        [ g.security.keepass.package ]
        ++ lib.optionals (desktop == "sway") (
          with pkgs;
          [
            keepmenu
            xsel
            ydotool
            wl-clipboard
          ]
        );
      sessionVariables.KPDB = kpdb;
      file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI { } {
        General.LastActiveDatabase = kpdb;
      };
    };
    xdg.configFile =
      lib.optionalAttrs (desktop == "sway") {
        "keepmenu/config.ini".text = lib.generators.toINI { } {
          dmenu = {
            dmenu_command = "tofi";
            pinentry = "${lib.getExe pkgs.pinentry-gnome3}";
          };
          dmenu_passphrase = {
            obscure = "True";
            obscure_color = "#555555";
          };
          database = {
            database_1 = kpdb;
            pw_cache_period_min = 360;
            terminal = "footclient";
            editor = "nvim";
            type_library = "ydotool";
          };
        };
      }
      // {
        "keepassxc/keepassxc.ini".text = lib.generators.toINI { } {
          General = {
            ConfigVersion = 2;
            MinimizeAfterUnlock = true;
          };
          Browser.Enabled = true;
          GUI = {
            ApplicationTheme = "classic";
            ColorPasswords = true;
            MinimizeOnClose = true;
            MinimizeToTray = true;
            MonospaceNotes = true;
            ShowTrayIcon = true;
            TrayIconAppearance = "monochrome-light";
          };

          Security.IconDownloadFallback = true;
        };
      };
  };
}
