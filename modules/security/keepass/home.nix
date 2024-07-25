{
  pkgs,
  lib,
  config,
  homeDirectory,
  desktop,
  ...
}:
let
  kmk0 = "${homeDirectory}/data/config/keeps/m0.kdbx";
in
{
  imports = [ ./keepfzf.nix ];
  options.modules.security.keepass.enable = lib.mkEnableOption "Enable keepass";

  config = lib.mkIf config.modules.security.keepass.enable {
    home = {
      packages =
        with pkgs;
        [ keepassxc ]
        ++ lib.optionals (desktop == "sway") [
          stash.keepmenu
          ydotool
          wl-clipboard
        ];
      sessionVariables.KPDB = kmk0;
      file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI { } {
        General.LastActiveDatabase = kmk0;
      };
    };
    xdg.configFile =
      lib.optionalAttrs (desktop == "sway") {
        "keepmenu/config.ini".text = lib.generators.toINI { } {
          dmenu = {
            dmenu_command = "${lib.getExe pkgs.tofi} --prompt-text=\"Keepmenu: \"";
            pinentry = "${lib.getExe pkgs.pinentry-gnome3}";
          };
          dmenu_passphrase = {
            obscure = "True";
            title_path = 25;
          };
          database = {
            database_1 = kmk0;
            pw_cache_period_min = 10;
            terminal = "${pkgs.foot}/bin/foot";
            editor = "${lib.getExe config.programs.neovim.package}";
            type_library = "${pkgs.ydotool}/bin/ydotool";
          };
          password_chars = {
            "punc min" = "!@#$%%";
          };
          password_char_presets = {
            "Minimal Punc" = "upper lower digits \"punc min\"";
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
