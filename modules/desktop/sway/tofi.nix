{
  pkgs,
  libx,
  ...
}: let
  inherit (libx) fonts colors;
in {
  home.packages = with pkgs; [tofi];
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
      font = ${fonts.interface.name}
      font-variations = "wght ${fonts.interface.weight}"
      selection-color = #${colors.extra.lavender}
      prompt-color =  #${colors.extra.lavender}
      text-color = #${colors.extra.overlay1}
      prompt-color = #${colors.extra.lavender}
      background-color = #${colors.default.background}
      prompt-padding = 2
      anchor = top
      width = 0
      horizontal = true
      font-size = 11
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 10
      corner-radius = 12
      height = 30
      margin-top = 5
      margin-left = 5
      margin-right = 5
      margin-bottom = 0
      padding-top = 3
      padding-bottom = 0
      padding-left = 10
      padding-right = 10
    '';
  };
}
