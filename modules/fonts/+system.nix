{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.fonts;
  optionals =
    { fonttype, typeface }:
    lib.optionals (cfg."${fonttype}".typeface == typeface) [ cfg."${fonttype}".name ];
  setFontConfig =
    typeface:
    (optionals {
      inherit typeface;
      fonttype = "interface";
    })
    ++ (optionals {
      inherit typeface;
      fonttype = "shell";
    });
in
{
  config = {
    nixpkgs.config.joypixels.acceptLicense = true;
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;
      packages = import ./allFonts.nix { inherit pkgs config; };
      fontconfig = {
        antialias = true;
        defaultFonts = {
          serif = setFontConfig "serif" ++ [
            "Libertinus Serif"
            "Gelasio"
          ];
          sansSerif = setFontConfig "sansSerif" ++ [
            "Work Sans"
            "Inter"
          ];
          monospace = setFontConfig "monospace" ++ [
            "Roboto Mono"
            "Symbols Nerd Font Mono"
          ];
          emoji = [
            "Joypixels"
          ];
        };
        enable = true;
        hinting = {
          autohint = false;
          enable = true;
          style = "slight";
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "light";
        };
      };
    };
  };
}