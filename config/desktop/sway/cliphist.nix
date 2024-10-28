{ pkgs, config, ... }:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  clipfzf = pkgs.writers.writeBash "clipfzf" ''
    foot --app-id=clipboard --title=Clipboard -- cliphist list | fzf  -d '\t' --with-nth 2 --prompt 'pick > ' --bind 'tab:up' --cycle | cliphist decode | wl-copy
  '';
in
{
  services.cliphist.enable = true;
  home.packages = [ pkgs.cliphist ];
  wayland.windowManager.sway.config = {
    keybindings = {
      "${mod}+v" = "exec $toggle_window --width 90ppt --height 90 --kill true --id clipboard -- '${clipfzf}'";
    };
  };
}
