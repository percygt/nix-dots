{ isGeneric, ... }:
if (!isGeneric) then
  {
    imports = [
      ./bluetooth.nix
      ./intel.nix
      ./nvidia.nix
      ./adb.nix
    ];
  }
else
  { }
