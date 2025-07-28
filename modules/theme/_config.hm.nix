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
    scheme = config.modules.themes.colorscheme;
  };
}
