{
  lib,
  config,
  flakeDirectory,
  ...
}: let
  inherit ((import ./file-associations.nix)) associations;
in {
  options = {
    desktop.modules.xdg = {
      enable =
        lib.mkEnableOption "Enables xdg";
      linkDirsToData.enable =
        lib.mkEnableOption "Enables linking personal data directory";
    };
  };
  config = lib.mkIf config.desktop.modules.xdg.enable {
    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = associations;
      };
      configHome = config.home.homeDirectory + "/.config";
      cacheHome = config.home.homeDirectory + "/.local/cache";
      dataHome = config.home.homeDirectory + "/.local/share";
      stateHome = config.home.homeDirectory + "/.local/state";
      userDirs = {
        enable = true;
        createDirectories = lib.mkDefault true;

        download = config.home.homeDirectory + "/downloads";
        pictures = config.home.homeDirectory + "/pictures";
        music = config.home.homeDirectory + "/music";

        documents = config.home.homeDirectory;
        desktop = config.home.homeDirectory;
        publicShare = config.home.homeDirectory;
        templates = config.home.homeDirectory;
        videos = config.home.homeDirectory;

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/pictures/screenshots";
        };
      };
    };

    gtk.gtk3 = {
      bookmarks = [
        "file:///${flakeDirectory}"
        "file://${config.home.homeDirectory}/data"
        "file://${config.home.homeDirectory}/windows"
        "file://${config.home.homeDirectory}/data/codebox"
        "file://${config.home.homeDirectory}/data/git-repo"
        "file://${config.home.homeDirectory}/.local/share"
        "file://${config.home.homeDirectory}/.config"
        "file://${config.home.homeDirectory}/data/playground"
      ];
    };

    home.activation = lib.mkIf config.desktop.modules.xdg.linkDirsToData.enable {
      linkXdgDirs =
        lib.hm.dag.entryAfter ["linkGeneration"]
        ''
          if [ ! -e "${config.home.homeDirectory}/pictures/.not_empty" ] && [ -e "${config.home.homeDirectory}/data" ]; then
              rm -rf "${config.home.homeDirectory}/pictures"
              ln -s "${config.home.homeDirectory}/data/home/pictures" "${config.home.homeDirectory}/pictures"
          fi
          if [ ! -e "${config.home.homeDirectory}/downloads/.not_empty" ] && [ -e "${config.home.homeDirectory}/data" ]; then
              rm -rf "${config.home.homeDirectory}/downloads"
              ln -s "${config.home.homeDirectory}/data/home/downloads" "${config.home.homeDirectory}/downloads"
          fi
          if [ ! -e "${config.home.homeDirectory}/music/.not_empty" ] && [ -e "${config.home.homeDirectory}/data" ]; then
              rm -rf "${config.home.homeDirectory}/music"
              ln -s "${config.home.homeDirectory}/data/home/music" "${config.home.homeDirectory}/music"
          fi
        '';
    };
  };
}
