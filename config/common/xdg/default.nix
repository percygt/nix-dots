{ lib, config, ... }:
let
  g = config._general;
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = import ./file-associations.nix;
    };
    configHome = g.homeDirectory + "/.config";
    cacheHome = g.homeDirectory + "/.local/cache";
    dataHome = g.homeDirectory + "/.local/share";
    stateHome = g.homeDirectory + "/.local/state";
    userDirs = {
      enable = true;
      createDirectories = lib.mkDefault true;

      download = g.homeDirectory + "/downloads";
      pictures = g.homeDirectory + "/pictures";
      music = g.homeDirectory + "/music";

      documents = g.homeDirectory;
      desktop = g.homeDirectory;
      publicShare = g.homeDirectory;
      templates = g.homeDirectory;
      videos = g.homeDirectory;

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${g.homeDirectory}/pictures/screenshots";
      };
    };
  };

  gtk.gtk3 = {
    bookmarks = [
      "file:///${g.flakeDirectory}"
      "file://${g.homeDirectory}/data"
      "file://${g.homeDirectory}/windows"
      "file://${g.homeDirectory}/data/codebox"
      "file://${g.homeDirectory}/data/git-repo"
      "file://${g.homeDirectory}/.local/share"
      "file://${g.homeDirectory}/.config"
      "file://${g.homeDirectory}/data/playground"
    ];
  };

  home.activation = {
    linkXdgDirs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if [ ! -e "${g.homeDirectory}/pictures/.not_empty" ] && [ -e "${g.homeDirectory}/data" ]; then
          rm -rf "${g.homeDirectory}/pictures"
          ln -s "${g.homeDirectory}/data/home/pictures" "${g.homeDirectory}/pictures"
      fi
      if [ ! -e "${g.homeDirectory}/downloads/.not_empty" ] && [ -e "${g.homeDirectory}/data" ]; then
          rm -rf "${g.homeDirectory}/downloads"
          ln -s "${g.homeDirectory}/data/home/downloads" "${g.homeDirectory}/downloads"
      fi
      if [ ! -e "${g.homeDirectory}/music/.not_empty" ] && [ -e "${g.homeDirectory}/data" ]; then
          rm -rf "${g.homeDirectory}/music"
          ln -s "${g.homeDirectory}/data/home/music" "${g.homeDirectory}/music"
      fi
    '';
  };
}
