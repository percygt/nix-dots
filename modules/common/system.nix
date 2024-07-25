{ username, pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./configuration.nix
    ./console.nix
    ./locale.nix
    ./nix.nix
    ./nixpkgs/overlay.nix
    ./nixpkgs/config.nix
  ];
  home-manager.users.${username} = import ./home.nix;
  environment.systemPackages = import ./packages.nix pkgs;
}
