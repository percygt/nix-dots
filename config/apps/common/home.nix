{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mission-center
    qalculate-gtk
    shotwell
    audacity
    amberol
    foliate
    mumble
    gimp
    font-manager
    inkscape
    krita
    # obsidian
    logseq
    gnome-podcasts
    lutris
  ];
}
