{
  pkgs,
  libx,
  isGeneric,
  username,
  ...
}:
if isGeneric
then {imports = [./home];}
else {imports = [./system.nix];}
