{
  lib,
  pkgs,
  ...
}:
let
  fontModule = {
    name =
      with lib;
      mkOption {
        type = types.str;
        default = "VictorMono Nerd Font";
      };
    style =
      with lib;
      mkOption {
        type = with types; either (listOf str) str;
        default = "Regular";
      };
    typeface =
      with lib;
      mkOption {
        type = types.nullOr (
          types.enum [
            "serif"
            "sansSerif"
            "monospace"
          ]
        );
        default = "monospace";
      };
    package = lib.mkOption {
      type = with lib.types; package;
      default = pkgs.nerd-fonts.victor-mono;
    };
    size =
      with lib;
      mkOption {
        type = types.float;
        default = 14.0;
      };
  };
in
{
  options.modules.fonts = {
    shell = fontModule;
    interface = fontModule;
    propo = fontModule;
    app = fontModule;
    icon = fontModule;
    extraFonts = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
    };
  };
}
