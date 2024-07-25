{ config, inputs, ... }:
{
  imports = [
    ./module.nix
    inputs.base16.homeManagerModule
  ];
  scheme = config.modules.theme.colorscheme;
}
