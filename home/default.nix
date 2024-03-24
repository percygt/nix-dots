{
  lib,
  desktop,
  inputs,
  outputs,
  is_generic_linux,
  ...
}: {
  imports =
    [
      ./common
      ./cli
      ./desktop
      ./editor
      ./bin
      ./terminal
      ./shell
      ./security
      ./users
    ]
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default
    ]
    ++ lib.optionals is_generic_linux [
      ./generic
      inputs.xremap.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
    ];
  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.overlays.default
      inputs.hyprland.overlays.default
      inputs.hyprland-contrib.overlays.default
      inputs.hyprlock.overlays.default
    ];
}
