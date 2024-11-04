{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  PASSWORD_STORE_DIR = g.security.gpg.passDir;
in
{
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
      tofi-pass
    ];
  };
}
