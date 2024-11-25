{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.base16.homeManagerModule
  ];
  config = {
    scheme = config.modules.theme.colorscheme;
  };
}
