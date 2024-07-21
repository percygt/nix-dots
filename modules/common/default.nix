{ isGeneric, ... }:
if (!isGeneric) then
  { imports = [ ./system.nix ]; }
else
  {
    imports = [
      ./home.nix
      ./fonts/home.nix
      ./theme/home.nix
    ];
  }
