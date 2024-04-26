{pkgs, ...}: {
  programs = {
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    gnome.nautilus
    zoom-us
    audacity
    # bambu-studio
    loupe
    # mumble
    # obsidian
    # rambox
    # signal-desktop
    # todoist-electron
    # xorg.xlsclients
  ];
}
