{
  pkgs,
  lib,
  config,
  ...
}:
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
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${mod}+v" = "exec ddapp -t 'clipboard' -n 'Clipboard' -w 90 -h 90 -k true -c ${cliphistFzfSixel}";
  };
}
