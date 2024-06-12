{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      youtube-music
      chromium
      qalculate-gtk
      audacity
      amberol
      foliate
      mumble
      obsidian
      gnome-podcasts
    ];
  };
  programs = {
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
  environment.systemPackages = with pkgs; [
    cinnamon.nemo-with-extensions
  ];
}
