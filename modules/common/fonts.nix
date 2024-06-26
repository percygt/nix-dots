{
  pkgs,
  libx,
  ...
}: {
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = libx.fonts.packages pkgs;
    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = ["Source Serif"];
        sansSerif = ["Work Sans" "Rubik" "Noto Sans"];
        monospace = ["JetBrainsMono Nerd Font" "VictorMono Nerd Font" "GeistMono Nerd Font"];
        emoji = ["Joypixels" "Noto Color Emoji"];
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
}
