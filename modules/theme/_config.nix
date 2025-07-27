{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.base16.nixosModule
  ];
  config = {
    scheme = config.modules.themes.colorscheme;
  };
}
