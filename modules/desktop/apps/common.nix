{
  pkgs,
  username,
  lib,
  config,
  ...
}:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      chromium
      qalculate-gtk
      audacity
      amberol
      foliate
      mumble
      gimp
      font-manager
      inkscape
      krita
      obsidian
      logseq
      gnome-podcasts
      lutris
    ];
  };
  programs = {
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
  environment.systemPackages = with pkgs; [ cinnamon.nemo-with-extensions ];
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/Mumble"
          ".local/share/lutris"
          ".config/Mumble"
          ".config/Logseq"
          ".local/cache/amberol"
        ];
      };
    };
  };
}
