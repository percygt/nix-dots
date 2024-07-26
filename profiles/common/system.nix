{ username, ... }:
{
  imports = [
    ./fonts.nix
    ./theme.nix
  ];

  home-manager.users.${username} = import ./home.nix;
}
