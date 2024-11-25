{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.base16.nixosModule
  ];
  config = lib.mkIf config.modules.theme.enable {
    scheme = config.modules.theme.colorscheme;
    modules.theme.colors = config.scheme;
  };
}
