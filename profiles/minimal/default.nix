{ inputs, ... }:
{
  imports = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ];
  modules.editor.neovim.enable = true;
  modules.cli.starship.enable = true;
}
