{ username, ... }:
{
  imports = [
    ./xremap.nix
    ./dconf
  ];
  home-manager.users.${username} = import ./home.nix;
}
