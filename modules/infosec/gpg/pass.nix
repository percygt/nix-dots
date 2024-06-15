{
  pkgs,
  config,
  lib,
  ...
}: let
  PASSWORD_STORE_DIR = "${config.home.homeDirectory}/data/config/pass";
in {
  options.infosec.gpg.pass.enable = lib.mkEnableOption "Enable pass";
  config = lib.mkIf config.infosec.gpg.pass.enable {
    programs = {
      password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [
          exts.pass-otp
          exts.pass-import
        ]);
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
