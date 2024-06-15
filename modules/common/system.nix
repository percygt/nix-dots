{
  username,
  lib,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
    ./console.nix
    ./locale.nix
    ./nix.nix
    ./fonts.nix
    ./nixpkgs/overlay.nix
    ./nixpkgs/config.nix
  ];
  environment.persistence = lib.mkIf config.core.ephemeral.enable {
    "/persist".users.${username}.directories = [".local/cache/nix-index"];
  };
  home-manager.users.${username} = import ./home.nix;
}
