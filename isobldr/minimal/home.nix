{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  imports = [
    "${self}/modules/cli/starship.nix"
    "${self}/modules/editor/neovim/home.nix"
  ];

  programs.home-manager.enable = true;

  editor.neovim.home.enable = true;

  cli.starship.home.enable = true;

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
