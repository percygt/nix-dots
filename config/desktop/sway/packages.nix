{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nemo-with-extensions
    wpa_supplicant_gui
    swayidle
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
    desktop-file-utils
    wl-screenrec
    libnotify
    adwaita-icon-theme
  ];
}
