{
  desktop,
  lib,
  ...
}: {
  imports = lib.optionals (desktop != null) [
    ./${desktop}/home.nix
    ./apps/home.nix
    ./common/home.nix
  ];
}
