{
  pkgs,
  ...
}:
{
  imports = [
    ./loupe.nix
    ./mpv.nix
    ./quickemu.nix
    ./zathura.nix
  ];

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
    pinta
    inkscape
    krita
    # obsidian
    logseq
    gnome-podcasts
    lutris
  ];
}
