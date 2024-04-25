{pkgs, ...}: {
  home.packages = with pkgs; [
    grim
    kanshi
    libnotify
    pamixer
    slurp
    wdisplays
    wl-clipboard
    wl-mirror
    xdg-utils
    xwayland
    btop
  ];
}
