{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  imports = [
    "${self}/modules/common/nix.nix"
    "${self}/modules/cli/starship.nix"
    "${self}/modules/editor/neovim"
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
}
