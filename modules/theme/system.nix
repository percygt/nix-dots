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
    scheme = config.modules.theme.colorscheme;
  };
}
