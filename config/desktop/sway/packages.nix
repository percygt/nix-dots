{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wpa_supplicant_gui
    # mako
    swayidle
    swaylock-effects
    playerctl
    qpwgraph
    brightnessctl
    autotiling
    wlsunset
    grim
    kanshi
    libnotify
    pamixer
    wev
    slurp
    wdisplays
    wl-clipboard
    ydotool
    xdg-utils
    xwayland
    rofimoji
    desktop-file-utils
    wl-screenrec
    libnotify
    adwaita-icon-theme
    tmux
  ];
}
