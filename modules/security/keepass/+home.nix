{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.security.keepass;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages =
        [ cfg.package ]
        ++ (with pkgs; [
          keepmenu
          xsel
          ydotool
          wl-clipboard
        ]);
    };
  };
}
