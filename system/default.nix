{
  lib,
  modulesPath,
  desktop,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./bin
    ./common
    ./core
    ./drivers
    ./desktop
    ./users
    ./infosec
    ./net
    # ./extra
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
