{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.utility.uad.enable {
    home.packages = with pkgs; [ universal-android-debloater ];
    xdg.desktopEntries = {
      uad-ng = {
        name = "Universal Android Debloater";
        type = "Application";
        comment = "Remove pre-installed apps on your Android device";
        icon = "uad-ng";
        exec = "uad-ng";
        terminal = false;
        categories = [
          "Utility"
          "Development"
        ];
        settings = {
          Hidden = "false";
          Keywords = "UAD";
        };
      };
    };

  };
}
