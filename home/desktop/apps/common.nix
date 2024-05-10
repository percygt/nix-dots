{pkgs, ...}: {
  programs = {
    mpv.enable = true;
    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };
  };

  home.packages = with pkgs; [
    stash.anime-game-launcher
    stash.anime-games-launcher
    stash.anime-borb-launcher
    stash.honkers-railway-launcher
    stash.honkers-launcher
    chromium
    qalculate-gtk
    gnome.nautilus
    audacity
    nvitop
    loupe
    zathura
    # mumble
    obsidian
  ];
}
