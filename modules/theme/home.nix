{ config, inputs, ... }:
{
  imports = [
    ./module.nix
    inputs.base16.homeManagerModule
  ];
  config = {
    scheme = config.modules.theme.colorscheme;
  };
}
