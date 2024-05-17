{
  desktop,
  lib,
  ...
}: {
  imports = [
    ./${desktop}.nix
    ./common.nix
  ];
}
