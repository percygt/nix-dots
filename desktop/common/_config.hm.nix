{
  pkgs,
  ...
}:
{
  xdg.configFile."swayimg/config".source = ./swayimgrc;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = import ./.mimeApps.nix;
    associations.added = import ./.mimeApps.nix;
  };
  home.packages = with pkgs; [
    swayimg # default image viewer
    # mpv # default video player
    vlc # default video player
    zathura # default pdf viewer
    lollypop # default audio player
    gnome-calculator
    gnome-firmware
    shotwell
    snapshot
    font-manager
    coulr
    pinta
    devtoolbox
    clapgrep
    # foliate
    # gimp
    # logseq
    # lutris
  ];
}
