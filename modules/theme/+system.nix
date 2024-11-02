{ inputs, config, ... }:
{
  imports = [
    inputs.base16.nixosModule
  ];
  config = {
    scheme = config.modules.theme.colorscheme;
  };
}
