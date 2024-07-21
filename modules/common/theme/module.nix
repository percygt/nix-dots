{
  lib,
  config,
  inputs,
  ...
}:
{
  options.setTheme = {
    colorscheme = lib.mkOption {
      description = "Current colorscheme";
      type = with lib.types; either attrs path;
      default = "${inputs.tt-schemes}/base24/one-dark.yaml";
    };
    colors = lib.mkOption {
      description = "Current colors";
      type = lib.types.anything;
      default = config.scheme;
    };
    opacity = lib.mkOption {
      description = "Background opacity";
      type = lib.types.float;
      default = 0.8;
    };
  };
}
