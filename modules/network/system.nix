{ isGeneric, ... }:
if (!isGeneric) then
  {
    imports = [
      ./avahi.nix
      ./syncthing.nix
      ./tailscale.nix
    ];
  }
else
  { }
