{
  lib,
  config,
  pkgs,
  ...
}:
{
  options._general = {
    desktop = {
      sway.package = lib.mkOption {
        description = "sway pakage to use";
        type = lib.types.package;
        default = pkgs.swayfx;
      };
    };
    username = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = "percygt";
    };
    homeDirectory = lib.mkOption {
      description = "Home directory";
      default = "/home/${config._general.username}";
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      description = "State version";
      default = "23.05";
      type = lib.types.str;
    };
  };
}
