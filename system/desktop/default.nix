{
  desktop,
  lib,
  ...
}: {
  imports = lib.optionals (desktop != null) [
    ./${desktop}
    ./flatpak.nix
  ];
}
