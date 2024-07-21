{
  pkgs,
  config,
  lib,
  libx,
  username,
  ...
}:
let
  inherit (libx.colorConvert) hexToRGBString;
  c = config.setTheme.colors;
  f = config.setFonts.shell;
in
{
  console = {
    font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    colors = c.toList;
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    autologinUser = username;
    fonts = [
      {
        inherit (f) name;
        package = f.package;
      }
    ];
    extraConfig = ''
      font-size=${builtins.toString f.size}
      xkb-layout=us
      xkb-options=compose:caps
      xkb-repeat-rate=25
      palette=custom
      palette-black=${hexToRGBString ", " c.base01}
      palette-red=${hexToRGBString ", " c.base08}
      palette-green=${hexToRGBString ", " c.base0B}
      palette-yellow=${hexToRGBString ", " c.base09}
      palette-blue=${hexToRGBString ", " c.base0D}
      palette-magenta=${hexToRGBString ", " c.base0C}
      palette-cyan=${hexToRGBString ", " c.base06}
      palette-light-grey=${hexToRGBString ", " c.base04}
      palette-dark-grey=${hexToRGBString ", " c.base03}
      palette-light-red=${hexToRGBString ", " c.base12}
      palette-light-green=${hexToRGBString ", " c.base14}
      palette-light-yellow=${hexToRGBString ", " c.base13}
      palette-light-blue=${hexToRGBString ", " c.base16}
      palette-light-magenta=${hexToRGBString ", " c.base17}
      palette-light-cyan=${hexToRGBString ", " c.base15}
      palette-white=${hexToRGBString ", " c.base05}
      palette-foreground=${hexToRGBString ", " c.base05}
      palette-background=${hexToRGBString ", " c.base00}
    '';
  };
}
