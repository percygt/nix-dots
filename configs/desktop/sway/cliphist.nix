{ pkgs, config, ... }:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  cliphistFzfSixel = pkgs.writers.writeBash "cliphistFzfSixel" ''
    foot --app-id=clipboard --title=Clipboard -- cliphist-fzf-sixel
  '';
in
{
  services.cliphist.enable = true;
  home.packages = with pkgs; [
    cliphist
    chafa
    libsixel
  ];
  wayland.windowManager.sway.config = {
    keybindings = {
      "${mod}+v" = "exec $toggle_window --width 90 --height 90 --kill true --id clipboard -- ${cliphistFzfSixel}";
    };
  };
}
