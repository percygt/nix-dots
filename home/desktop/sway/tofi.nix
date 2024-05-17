{
  pkgs,
  libx,
  lib,
  config,
  ...
}: let
  inherit (libx) fonts colors;
  kmk0 = "${config.home.homeDirectory}/data/keeps/m0.kdbx";
in {
  home.packages = with pkgs; [tofi] ++ lib.optionals config.infosec.keepass.enable [stash.keepmenu ydotool wl-clipboard];
  xdg.configFile = {
    "keepmenu/config.ini".text = lib.mkIf config.infosec.keepass.enable (lib.generators.toINI {} {
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
    });
    "tofi/config".text = ''
      # vim: ft=dosini
      ; BEHAVIOR OPTIONS
      hide-cursor = true
      text-cursor = false
      history = true
      fuzzy-match = false
      require-match = true
      auto-accept-single = false
      hide-input = false
      drun-launch = false
      late-keyboard-init = false
      multi-instance = false
      ascii-input = true

      # STYLE OPTIONS
      font = ${fonts.interface.name}
      font-variations = "wght 700"
      selection-color = #${colors.extra.lavender}
      prompt-color =  #${colors.extra.lavender}
      text-color = #${colors.extra.overlay1}
      prompt-color = #${colors.extra.lavender}
      background-color = #${colors.default.background}
      prompt-padding = 2
      anchor = top
      height = 30
      width = 0
      horizontal = true
      font-size = 10
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 10
      corner-radius = 0
      # margin-top = 2
      # margin-left = 2
      # margin-right = 2
      # margin-bottom = 1
      padding-top = 6
      padding-left = 5
      padding-right = 5
    '';
  };
}
