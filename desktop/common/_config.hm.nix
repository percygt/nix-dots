{
  pkgs,
  ...
}:
{
  xdg.configFile."swayimg/config".source = ./swayimgrc;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = import ./__mimeApps.nix;
    associations.added = import ./__mimeApps.nix;
    associations.removed = import ./__removedMime.nix;
  };
  programs.nheko.enable = true;
  home.packages = with pkgs; [
    swayimg # default image viewer
    mpv # default video player
    zathura # default pdf viewer
    lollypop # default audio player
    gnome-calculator
    gnome-firmware
    shotwell
    snapshot
    font-manager
    coulr
    emulsion-palette
    paleta
    pinta
    devtoolbox
    clapgrep
    libreoffice-qt
    # foliate
    # gimp
    # logseq
    # lutris
  ];
}
