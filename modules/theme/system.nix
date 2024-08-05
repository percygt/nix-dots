{ inputs, config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./module.nix
    inputs.base16.nixosModule
  ];
  config = {
    home-manager.users.${g.username} = import ./home.nix;
    scheme = config.modules.theme.colorscheme;
  };
}
