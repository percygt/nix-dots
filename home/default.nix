{
  lib,
  desktop,
  inputs,
  isGeneric,
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
      # ./users
      # ./backup
    ]
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default
    ]
    ++ lib.optionals isGeneric [
      ./generic
    ];
}
