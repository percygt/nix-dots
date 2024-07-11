{
  lib,
  config,
  isGeneric,
  ...
}:
if !isGeneric
then {imports = [./system.nix];}
else {imports = [./home.nix];}
