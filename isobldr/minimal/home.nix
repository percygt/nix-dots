{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  imports = [
    "${self}/modules/cli/starship.nix"
    "${self}/modules/common/nix.nix"
  ];

  programs.home-manager.enable = true;

  home = {
    inherit
      username
      stateVersion
      homeDirectory
      ;
    shellAliases = {
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  cli.starship.enable = true;
}
