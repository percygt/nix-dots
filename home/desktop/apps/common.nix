{pkgs, ...}: {
  programs = {
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    stash.anime-game-launcher
    stash.anime-games-launcher
    stash.anime-borb-launcher
    stash.honkers-railway-launcher
    stash.honkers-launcher

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
