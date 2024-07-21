{
  lib,
  config,
  pkgs,
  ...
}:
let
  fontModule = {
    name = with lib; mkOption { type = types.str; };
    style = with lib; mkOption { type = types.str; };
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
        default = null;
      };
    package = lib.mkOption {
      type = with lib; types.either (types.enum [ "nerdfont" ]) types.package;
      default = config.setFonts.nerdfontPackages;
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
  options.setFonts = {
    shell = fontModule;
    interface = fontModule;
    icon = fontModule;
    nerdfontPackages = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nerdfonts;
    };
    extraFontPackages = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
    };
  };
}
