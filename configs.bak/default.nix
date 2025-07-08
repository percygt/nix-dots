{
  username,
  isGeneric,
  lib,
  homeMarker,
  ...
}:
if (!isGeneric && !homeMarker) then
  {
    imports = [
      ./+system
      ./+system.nix
      ./+common.nix
    ];
    home-manager.users.${username} = {
      imports = [
        ./+home
        ./+home.nix
      ] ++ lib.optionals homeMarker [ ./+common.nix ];
    };
  }
else
  {
    imports = [
      ./+home
      ./+home.nix
    ] ++ lib.optionals homeMarker [ ./+common.nix ];
  }
