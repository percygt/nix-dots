{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.security.common.fprintd.enable = lib.mkOption {
    description = "Enable hardening";
    type = lib.types.bool;
    default = false;
  };
  config = lib.mkIf config.modules.security.common.fprintd.enable {
    services.fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-vfs0090;
      };
    };
  };
}
