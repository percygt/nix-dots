{pkgs, self, config,...}: let
  inherit (import "${self}/lib/mkUI.nix" {inherit pkgs config;}) fonts;
in {
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    inherit (fonts) packages;
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        serif = fonts.serif.names;
        sansSerif = fonts.sansSerif.names;
        monospace = fonts.monospace.names;
        emoji = fonts.emoji.names;
      };
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
}
