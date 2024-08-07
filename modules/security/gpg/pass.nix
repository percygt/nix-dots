{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._general;
  cfg = config.modules.security.gpg;
  PASSWORD_STORE_DIR = g.gpg.passDir;
in
{
  options.modules.security.gpg.pass.enable = lib.mkOption {
    description = "Enable pass";
    type = lib.types.bool;
    default = cfg.enable;
  };
  config = lib.mkIf config.modules.security.gpg.pass.enable {
    programs = {
      password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
        settings = {
          inherit PASSWORD_STORE_DIR;
        };
      };
    };
    home.packages = with pkgs; [
      zbar
      wl-clipboard
    ];
  };
}
