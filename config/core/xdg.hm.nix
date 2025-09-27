{
  lib,
  config,
  ...
}:
let
  g = config._global;
  x = g.xdg;
  u = x.userDirs;
in
{
  xdg = {
    enable = true;
    inherit (x)
      configHome
      cacheHome
      dataHome
      stateHome
      ;
    userDirs = {
      enable = true;
      createDirectories = lib.mkDefault true;
      inherit (u)
        download
        pictures
        music
        documents
        desktop
        publicShare
        templates
        videos
        extraConfig
        ;
    };
  };
}
