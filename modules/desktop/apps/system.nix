{username, ...}: {
  imports = [
    ./flatpak.nix
    ./common.nix
    ./brave
  ];
  home-manager.users.${username} = import ./home.nix;
}
