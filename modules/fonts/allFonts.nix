{ pkgs, config, ... }:
let
  cfg = config.modules.fonts;
  addPackage =
    pkg:
    if (builtins.typeOf pkg == "string" && pkg == "nerdfont") then
      [ cfg.nerdfontPackages ]
    else
      [ pkg ];
  addPackages =
    (addPackage cfg.shell.package)
    ++ (addPackage cfg.interface.package)
    ++ (addPackage cfg.app.package)
    ++ (addPackage cfg.icon.package);
  defaultPkgs = with pkgs; [
    nerdfonts-fontconfig
    inter
    work-sans
    roboto-mono
    source-serif
    noto-fonts
    noto-fonts-cjk
    joypixels
    noto-fonts-emoji
    corefonts
    vistafonts
    ubuntu_font_family
  ];
in
defaultPkgs ++ addPackages ++ cfg.extraFonts
