{
  inputs,
  ...
}: {
  mkHomeManager = {
    hostname,
    stateVersion,
    pkgs,
    username ? "percygt",
    colors ? (import ./colors.nix).syft,
    homeDirectory ? "/home/${username}",
    flakeDirectory ? "${homeDirectory}/nix-dots",
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          pkgs
          inputs
          username
          colors
          hostname
          homeDirectory
          flakeDirectory
          stateVersion
          ;
      };
      modules = [
        ../home-manager/_profiles/${hostname}.nix
      ];
    };
}
