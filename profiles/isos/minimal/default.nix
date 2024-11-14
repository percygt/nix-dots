{ inputs, ... }:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  modules = {
    theme.enable = false;
    editor.neovim.enable = true;
  };
}
