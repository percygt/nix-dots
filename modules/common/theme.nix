{
  inputs,
  lib,
  username,
  config,
  ...
}:
let
  defaultColorscheme = import ./colorschemes/syft.nix;
in
{
  imports = [ inputs.base16.nixosModule ];
  options.setTheme = {
    colorscheme = lib.mkOption {
      description = "Current colorscheme";
      type = lib.types.attrs;
      default = defaultColorscheme;
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
  config = {
    scheme = defaultColorscheme;
    home-manager.users.${username} =
      { lib, ... }:
      {
        options.setTheme = {
          colorscheme = lib.mkOption {
            description = "Current colorscheme";
            type = lib.types.attrs;
            default = defaultColorscheme;
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
      };
  };
}
