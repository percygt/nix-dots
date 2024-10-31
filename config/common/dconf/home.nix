{ desktop, ... }:
{
  imports = [
    ./${desktop}.nix
    ./common.nix
  ];
}
