{
  pkgs,
  libx,
  ...
}: let
  inherit (libx) fonts colors;
in {
  home.packages = with pkgs; [tofi];
  xdg.configFile."tofi/config".text = ''
    # vim: ft=dosini

    ; SPECIAL OPTIONS
    ; include=

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
    selection-color = #${colors.bold}
    text-color = #${colors.default.foreground}
    background-color = #${colors.default.background}
    prompt-text = "> "
    prompt-padding = 2
    anchor = top
    width = 100%
    height = 24
    horizontal = true
    font-size = 10
    outline-width = 0
    border-width = 0
    min-input-width = 120
    result-spacing = 10
    padding-top = 5
    padding-bottom = 3
    padding-left = 0
    padding-right = 0
  '';
}
