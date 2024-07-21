{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.setFonts;
  addPackage =
    pkg:
    if (builtins.typeOf pkg == "string" && pkg == "nerdfont") then
      [ cfg.nerdfontPackages ]
    else
      [ pkg ];
  addPackages =
    (addPackage cfg.shell.package)
    ++ (addPackage cfg.interface.package)
    ++ (addPackage cfg.icon.package);
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
  imports = [ ./module.nix ];
  home-manager.users.${username} = import ./module.nix;
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages =
      (with pkgs; [
        nerdfonts-fontconfig
        inter
        work-sans
        source-serif
        noto-fonts
        noto-fonts-cjk
        joypixels
        noto-fonts-emoji
        corefonts
        vistafonts
        ubuntu_font_family
      ])
      ++ cfg.extraFontPackages
      ++ addPackages;
    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = setFontConfig "serif" ++ [
          "Source Serif"
          "Noto Serif"
        ];
        sansSerif = setFontConfig "sansSerif" ++ [
          "Inter"
          "Work Sans"
          "Noto Sans"
        ];
        monospace = setFontConfig "monospace" ++ [
          "Noto Sans Mono"
          "JetBrainsMono Nerd Font"
          "Symbols Nerd Font Mono"
        ];
        emoji = [
          "Joypixels"
          "Noto Color Emoji"
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
}
