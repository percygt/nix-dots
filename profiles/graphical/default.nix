{ inputs, config, ... }:
let
  g = config._general;
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];
  modules = {
    theme.enable = true;
    editor.neovim.enable = true;
    cli.starship.enable = true;
  };

  home-manager.users.${g.username} = import ./home.nix;
}
