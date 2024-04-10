{
  imports = [
    ./set_credentials.nix
    ./clone_repos.nix
    ./set_secrets.nix
    ./set_disks.nix
    ./install_nixos.nix
    ./post_install.nix
  ];
}
