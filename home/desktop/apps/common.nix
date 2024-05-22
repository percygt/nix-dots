{pkgs, ...}: {
  home.packages = with pkgs; [
    youtube-music
    chromium
    qalculate-gtk
    audacity
    amberol
    foliate
    mumble
    obsidian
    gnome-podcasts
  ];
}
