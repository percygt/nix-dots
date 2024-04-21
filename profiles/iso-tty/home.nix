{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  imports = [
    "${self}/home/editor/neovim"
    "${self}/home/cli/starship.nix"
    "${self}/home/common/nix.nix"
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

  editor.neovim.enable = true;

  cli.starship.enable = true;
}
