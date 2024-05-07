{pkgs, ...}: {
  programs = {
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    gnome.nautilus
    # zoom-us
    audacity
    nvitop
    # bambu-studio
    loupe
    # mumble
    obsidian
    # rambox
    # signal-desktop
    # todoist-electron
    # xorg.xlsclients
  ];
}
