{ username, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./console.nix
    ./locale.nix
    ./nix.nix
    ./fonts
    ./nixpkgs/overlay.nix
    ./nixpkgs/config.nix
    ./theme
  ];
  home-manager.users.${username} = import ./home.nix;
  environment.systemPackages = import ./packages.nix pkgs;
}
