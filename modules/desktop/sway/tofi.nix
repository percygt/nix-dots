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