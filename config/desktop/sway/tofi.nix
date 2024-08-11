{ pkgs, config, ... }:
let
  f = config.modules.fonts.interface;
  c = config.modules.theme.colors.withHashtag;
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
      text-color = ${c.base04}
      background-color = ${c.base10}
      prompt-padding = 2
      anchor = top
      width = 0
      horizontal = true
      font-size = 12
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 10
      corner-radius = 0
      height = 30
      margin-top = 0
      margin-left = 0
      margin-right = 0
      margin-bottom = 0
      padding-top = 5
      padding-bottom = 0
      padding-left = 10
      padding-right = 10
    '';
  };
}
