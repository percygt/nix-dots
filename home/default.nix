{
  lib,
  desktop,
  inputs,
  isGeneric,
  outputs,
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
      ./infosec
      ./dev
      ./browser
      # ./backup
    ]
    ++ lib.optionals isGeneric [
      ./generic
    ];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.overlays.default
      inputs.hyprland.overlays.default
      inputs.hyprland-contrib.overlays.default
      inputs.hyprlock.overlays.default
    ]
    ++ lib.optionals (desktop == "sway") [
      inputs.nixpkgs-wayland.overlay
    ];
}
