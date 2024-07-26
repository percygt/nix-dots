{ username, ... }:
{
  imports = [
    ./home-manager.nix
    ./configuration.nix
    ./console.nix
    ./locale.nix
    ./nix.nix
    ./nixpkgs/overlay.nix
    ./nixpkgs/config.nix
    ../users/${username}.nix
  ];
  home-manager.users.${username} = import ./home.nix;
}
