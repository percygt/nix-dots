{
  config,
  lib,
  homeDirectory,
  ...
}:
let
  g = config._global;
  x = config.xdg;
  u = x.userDirs;
in
{
  gtk.gtk3 = {
    bookmarks = [
      "file://${u.desktop}"
      "file://${u.download}"
      "file://${u.pictures}"
      "file://${u.music}"
      "file://${x.configHome}"
      "file://${x.dataHome}"
      "file://${g.dataDirectory}"
      "file://${g.flakeDirectory}"
      "file://${homeDirectory}/windows"
      "file://${g.dataDirectory}/codebox"
      "file://${g.dataDirectory}/git-repo"
      "file://${g.dataDirectory}/playground"
    ];
  };
  home.activation = {
    linkXdgDirs = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
      if [ ! -e "${u.pictures}/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${u.pictures}"
          ln -s "${g.dataDirectory}/home/pictures" "${u.pictures}"
      fi
      if [ ! -e "${u.download}/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${u.download}"
          ln -s "${g.dataDirectory}/home/downloads" "${u.download}"
      fi
      if [ ! -e "${u.music}/.not_empty" ] && [ -e "${g.dataDirectory}" ]; then
          rm -rf "${u.music}"
          ln -s "${g.dataDirectory}/home/music" "${u.music}"
      fi
    '';
  };
}
