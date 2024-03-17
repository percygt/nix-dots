{
  lib,
  homeDirectory,
  ...
}: {
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

      desktop = homeDirectory;
      documents = homeDirectory;
      music = homeDirectory;
      publicShare = homeDirectory;
      templates = homeDirectory;
      videos = homeDirectory;

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${homeDirectory}/pictures/screenshots";
      };
    };
  };
}
