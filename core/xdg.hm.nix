{
  lib,
  config,
  homeDirectory,
  ...
}:
let
  g = config._base;
in
{
  xdg = {
    enable = true;
    configHome = homeDirectory + "/.config";
    cacheHome = homeDirectory + "/.local/cache";
    dataHome = homeDirectory + "/.local/share";
    stateHome = homeDirectory + "/.local/state";
    userDirs = {
      enable = true;
      createDirectories = lib.mkDefault true;

      download = homeDirectory + "/downloads";
      pictures = homeDirectory + "/pictures";
      music = homeDirectory + "/music";

      documents = homeDirectory;
      desktop = homeDirectory;
      publicShare = homeDirectory;
      templates = homeDirectory;
      videos = homeDirectory;

      extraConfig.XDG_SCREENSHOTS_DIR = "${homeDirectory}/pictures/screenshots";
    };
  };

  gtk.gtk3 = {
    bookmarks = [
      "file:///${g.flakeDirectory}"
      "file://${g.dataDirectory}"
      "file://${homeDirectory}/windows"
      "file://${g.dataDirectory}/codebox"
      "file://${g.dataDirectory}/git-repo"
      "file://${homeDirectory}/.local/share"
      "file://${homeDirectory}/.config"
      "file://${g.dataDirectory}/playground"
    ];
  };

  home.activation = {
    linkXdgDirs = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
      if [ ! -e "${homeDirectory}/pictures/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${homeDirectory}/pictures"
          ln -s "${g.dataDirectory}/home/pictures" "${homeDirectory}/pictures"
      fi
      if [ ! -e "${homeDirectory}/downloads/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${homeDirectory}/downloads"
          ln -s "${g.dataDirectory}/home/downloads" "${homeDirectory}/downloads"
      fi
      if [ ! -e "${homeDirectory}/music/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${homeDirectory}/music"
          ln -s "${g.dataDirectory}/home/music" "${homeDirectory}/music"
      fi
    '';
  };
}
