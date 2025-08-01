{
  lib,
  homeDirectory,
  ...
}:
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
    };
  };
}
