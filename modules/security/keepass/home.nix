{
  pkgs,
  lib,
  config,
  homeDirectory,
  desktop,
  libx,
  ...
}:
let
  kmk0 = "${homeDirectory}/data/config/keeps/m0.kdbx";
in
{
  imports = [ ./keepfzf.nix ];
  options.modules.security.keepass.enable = libx.enableDefault "keepass";

  config = lib.mkIf config.modules.security.keepass.enable {
    home = {
      packages =
        (with pkgs; [ keepassxc ])
        ++ lib.optionals (desktop == "sway") (
          with pkgs;
          [
            keepmenu
            ydotool
            wl-clipboard
          ]
        );
      sessionVariables.KPDB = kmk0;
      file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI { } {
        General.LastActiveDatabase = kmk0;
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
            database_1 = kmk0;
            pw_cache_period_min = 10;
            terminal = "${lib.getExe config.programs.foot.package}";
            editor = "${lib.getExe config.programs.neovim.package}";
            type_library = "${lib.getExe pkgs.ydotool}";
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
