{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.security.fprintd.enable = lib.mkEnableOption "Enable fprintd";
  config = lib.mkIf config.modules.security.fprintd.enable {
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
