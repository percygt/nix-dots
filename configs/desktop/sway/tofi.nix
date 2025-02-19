{ pkgs, config, ... }:
let
  f = config.modules.fonts.interface;
  c = config.modules.themes.colors.withHashtag;
in
{
  home.packages = with pkgs; [ tofi ];
  xdg.configFile = {
    "tofi/config-dropdown".text = ''
      # vim: set ft=dosini :
      font = ${f.name}
      font-size = 12
      font-variations = "wght 700"
      border-width = 1
      outline-width = 0
      num-results = 9
      hide-cursor = true
      width = 90%
      height = 90%
      result-spacing = 10
      selection-color = ${c.base05}
      selection-match-color = ${c.base09}
      prompt-color =  ${c.base0D}
      text-color = ${c.base04}
      background-color = ${c.base01}
      outline-color = ${c.base17}
      border-color = ${c.base17}
      corner-radius = 6
    '';
    "tofi/config-horizontal-mid".text = ''
      # vim: set ft=dosini :
      font = ${f.name}
      font-size = 15
      font-variations = "wght 700"
      width = 80%
      height = 50
      border-width = 1
      outline-width = 0
      result-spacing = 10
      min-input-width = 120
      selection-color = ${c.base05}
      selection-match-color = ${c.base09}
      prompt-color =  ${c.base0D}
      text-color = ${c.base04}
      background-color = ${c.base01}
      outline-color = ${c.base17}
      border-color = ${c.base17}
      corner-radius = 6
      horizontal = true
      anchor = center
    '';
    "tofi/config".text = ''
      # vim: set ft=dosini :
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
      selection-match-color = ${c.base09}
      prompt-color =  ${c.base0D}
      text-color = ${c.base04}
      background-color = ${c.base01}
      prompt-padding = 2
      anchor = top
      width = 0
      horizontal = true
      font-size = 11
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
