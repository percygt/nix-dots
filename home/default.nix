{
  lib,
  desktop,
  inputs,
  useGenericLinux,
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
      ./users
      # ./backup
    ]
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default
    ]
    ++ lib.optionals useGenericLinux [
      ./generic
    ];
}
