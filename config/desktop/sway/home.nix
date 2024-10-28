{
  imports = [
    ./pomo.nix
    ./waybar
    ./shikane.nix
    ./swaync
    ./wlsunset.nix
    ./wayland-pipewire-idle-inhibit.nix
    ./polkit-gnome-authentication.nix
    ./ddapp.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swappy.nix
    ./tofi.nix
    ./sway-config.nix
    ./sway-extraConfig.nix
    ./sway-extraSessionCommands.nix
  ];
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "0";
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
