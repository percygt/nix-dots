{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mission-center
    qalculate-gtk
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
