{ username, ... }:
{
  imports = [
    ./flatpak.nix
    ./common
    ./brave
  ];
  home-manager.users.${username} = import ./home.nix;
}
