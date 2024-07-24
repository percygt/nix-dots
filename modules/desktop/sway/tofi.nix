{ pkgs, config, ... }:
let
  f = config.setFonts.interface;
  c = config.setTheme.colors.withHashtag;
in
{
  home.packages = with pkgs; [ tofi ];
  xdg.configFile = {
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
      font = ${f.name}
      font-variations = "wght 700"
      selection-color = ${c.base05}
      prompt-color =  ${c.base0D}
      text-color = ${c.base03}
      background-color = ${c.base00}
      prompt-padding = 2
      anchor = top
      width = 0
      horizontal = true
      font-size = 10
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 10
      corner-radius = 12
      height = 25
      margin-top = 5
      margin-left = 5
      margin-right = 5
      margin-bottom = 0
      padding-top = 0
      padding-bottom = 0
      padding-left = 10
      padding-right = 10
    '';
  };
}
