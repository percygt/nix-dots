{ pkgs, config, ... }:
let
  inherit (config._general) flakeDirectory;
  nxytConfigDir = "${flakeDirectory}/config/apps/browsers/nyxt";
in
{
  home.packages = [ pkgs.nyxt ];
  xdg = {
    configFile."nyxt/config.lisp".source = config.lib.file.mkOutOfStoreSymlink "${nxytConfigDir}/config.lisp";
    dataFile."nyxt/bookmarks.lisp".source = config.lib.file.mkOutOfStoreSymlink "${nxytConfigDir}/bookmarks.lisp";
  };
}
