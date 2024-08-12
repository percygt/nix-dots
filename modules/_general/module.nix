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
        description = "Sway pakage";
        type = lib.types.package;
        default = pkgs.swayfx;
      };
    };
    defaultShell = lib.mkOption {
      description = "Default shell";
      type = lib.types.str;
      default = "fish";
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
