{ isGeneric, ... }:
if (!isGeneric) then
  {
    imports = [
      ./kvm.nix
      ./docker.nix
      ./podman.nix
      ./vmvariant.nix
    ];
  }
else
  { }
