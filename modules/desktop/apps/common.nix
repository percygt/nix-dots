{
  pkgs,
  username,
  lib,
  config,
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
  environment.persistence = lib.mkIf config.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/Mumble"
          ".config/Mumble"
          ".local/cache/amberol"
        ];
      };
    };
  };
}
