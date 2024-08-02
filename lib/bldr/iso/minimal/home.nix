{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}:
{
  imports = [
    "${self}/modules/theme/home.nix"
    "${self}/modules/fonts/home.nix"
    "${self}/profiles/common/home.nix"
    "${self}/modules/cli/starship"
    "${self}/modules/editor/neovim/home.nix"
  ];

  programs.home-manager.enable = true;

  modules.editor.neovim.enable = true;

  modules.cli.starship.enable = true;

  home = {
    inherit username stateVersion homeDirectory;
    shellAliases.ni = "sudo nixos-install --no-root-passwd --flake";
  };
}
