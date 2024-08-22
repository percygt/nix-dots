{
  imports = [
    ./waybar
    ./swaync
    ./services.nix
    ./i3-quickterm.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swappy.nix
    ./tofi.nix
    ./config.nix
    ./extraConfig.nix
    ./extraSessionCommands.nix
  ];
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    swaynag.enable = true;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
  };
}
