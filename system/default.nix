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
    ./services
    ./users
    ./bin
    ./security
    ./network
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
