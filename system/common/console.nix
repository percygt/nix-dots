{
  pkgs,
  ui,
  ...
}: let
  inherit (ui) fonts colors;
  inherit (colors.conversions) hexToRGBString;
in {
  console = {
    earlySetup = true;
    packages = with pkgs; [terminus_font powerline-fonts];
    font = "ter-powerline-v32n";
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = [
      {
        inherit (fonts.console) name;
        package = fonts.console.package pkgs;
      }
    ];
    extraConfig = ''
      font-size=${builtins.toString fonts.console.size}
      xkb-layout=us
      palette=custom
      palette-black=${hexToRGBString "" colors.normal.black}
      palette-red=${hexToRGBString "" colors.normal.red}
      palette-green=${hexToRGBString "" colors.normal.green}
      palette-yellow=${hexToRGBString "" colors.normal.yellow}
      palette-blue=${hexToRGBString "" colors.normal.blue}
      palette-magenta=${hexToRGBString "" colors.normal.magenta}
      palette-cyan=${hexToRGBString "" colors.normal.cyan}
      palette-light-grey=${hexToRGBString "" colors.extra.overlay2}
      palette-dark-grey=${hexToRGBString "" colors.extra.overlay0}
      palette-light-red=${hexToRGBString "" colors.bright.red}
      palette-light-green=${hexToRGBString "" colors.bright.green}
      palette-light-yellow=${hexToRGBString "" colors.bright.yellow}
      palette-light-blue=${hexToRGBString "" colors.bright.blue}
      palette-light-magenta=${hexToRGBString "" colors.bright.magenta}
      palette-light-cyan=${hexToRGBString "" colors.bright.cyan}
      palette-white=${hexToRGBString "" colors.default.foreground}
      palette-foreground=${hexToRGBString "" colors.default.foreground}
      palette-background=${hexToRGBString "" colors.default.background}
    '';
  };
}
