{
  username,
  isGeneric,
  ...
}: let
  homeModules = [
    ./brave
    ./loupe.nix
    ./mpv.nix
    ./quickemu.nix
    ./spicetify.nix
    ./zathura.nix
  ];
in
  if isGeneric
  then {imports = homeModules;}
  else {
    imports = [
      ./flatpak.nix
      ./chromium.nix
      ./common.nix
    ];
    home-manager.users.${username} = {imports = homeModules;};
  }
