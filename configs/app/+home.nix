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
    gnome-firmware
    shotwell
    snapshot
    font-manager
    coulr
    pinta
    boxbuddy
    # foliate
    # gimp
    # logseq
    # lutris
  ];
}
