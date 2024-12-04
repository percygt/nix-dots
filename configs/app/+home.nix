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
    ./lollypop.nix
  ];

  home.packages = with pkgs; [
    gnome-calculator
    gnome-podcasts
    foliate
    # gimp
    font-manager
    pinta
    # logseq
    # lutris
  ];
}
