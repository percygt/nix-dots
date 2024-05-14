{pkgs, ...}: {
  home.packages = with pkgs; [
    # stash.anime-game-launcher
    # stash.anime-games-launcher
    # stash.anime-borb-launcher
    # stash.honkers-railway-launcher
    # stash.honkers-launcher
    chromium
    qalculate-gtk
    audacity
    audacious
    nvitop
    amberol
    # mumble
    obsidian
  ];
}
