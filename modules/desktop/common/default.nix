{ isGeneric, username, ... }:
let
  homeModules = [
    ./qt
    ./gtk
    ./xdg
    ./audio.nix
    ./automount.nix
  ];
in
if isGeneric then
  { imports = homeModules; }
else
  {
    imports = [
      ./xremap.nix
      ./dconf
    ];
    home-manager.users.${username} = {
      imports = homeModules;
    };
  }
