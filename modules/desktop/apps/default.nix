{username, ...}: {
  imports = [
    ./flatpak.nix
    ./chromium.nix
    ./common.nix
  ];
  home-manager.users.${username} = import ./home.nix;
}
