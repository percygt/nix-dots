{
  config,
  lib,
  homeDirectory,
  ...
}:
let
  g = config._base;
in
{
  gtk.gtk3 = {
    bookmarks = [
      "file://${g.dataDirectory}"
      "file://${homeDirectory}/windows"
      "file://${g.dataDirectory}/codebox"
      "file://${g.dataDirectory}/git-repo"
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
