{
  lib,
  modulesPath,
  desktop,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./common
    ./core
    ./desktop
    ./services
    ./users
    ./infosec
    ./net
    (modulesPath + "/installer/scan/not-detected.nix")
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
