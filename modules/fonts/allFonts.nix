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
    roboto-mono
    gelasio
    work-sans
    joypixels
  ];
in
defaultPkgs ++ addPackages ++ cfg.extraFonts
