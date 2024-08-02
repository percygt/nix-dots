{ inputs, username, ... }:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];
  modules = {
    theme.enable = true;
    editor.neovim.enable = true;
    cli.starship.enable = true;
  };

  home-manager.users.${username} = import ./home.nix;
}
