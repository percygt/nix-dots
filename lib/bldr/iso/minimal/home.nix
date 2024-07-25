{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}:
{
  imports = [
    "${self}/modules/cli/starship.nix"
    "${self}/modules/modules.editor.neovim.nix"
  ];

  programs.home-manager.enable = true;

  modules.editor.neovim.enable = true;

  modules.cli.starship.enable = true;

  home = {
    inherit username stateVersion homeDirectory;
    shellAliases = {
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };
}
