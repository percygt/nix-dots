{ username, ... }:
{
  imports = [ ./dconf ];
  home-manager.users.${username} = import ./home.nix;
}
