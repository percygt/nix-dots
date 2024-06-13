{username, ...}: {
  imports = [
    ./configuration.nix
    ./console.nix
    ./locale.nix
    ./nix.nix
    ./fonts.nix
    ./persist.nix
    ./nixpkgs/overlay.nix
    ./nixpkgs/config.nix
  ];
  home-manager.users.${username} = import ./home.nix;
}
