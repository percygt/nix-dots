{pkgs, ...}: {
  home.packages = with pkgs; [
    mako
    swayidle
    swaylock-effects
    playerctl
    qpwgraph
    brightnessctl
    autotiling
    wlsunset
    cycle-pulse-sink
    grim
    kanshi
    libnotify
    pamixer
    # nvtop
    wev
    slurp
    wdisplays
    wl-clipboard
    wtype
    xdg-utils
    xwayland
    rofimoji
    desktop-file-utils
    wl-screenrec
    libnotify
    gnome3.adwaita-icon-theme
  ];
}
