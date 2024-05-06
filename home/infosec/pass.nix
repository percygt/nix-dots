{
  pkgs,
  config,
  lib,
  ...
}: let
  PASSWORD_STORE_DIR = "${config.home.homeDirectory}/data/pass";
in {
  options = {
    infosec.pass.enable =
      lib.mkEnableOption "Enable pass";
  };

  config = lib.mkIf config.infosec.pass.enable {
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
    # services.pass-secret-service = {
    #   enable = true;
    #   storePath = PASSWORD_STORE_DIR;
    #   extraArgs = ["-e${config.programs.password-store.package}/bin/pass"];
    # };
    home.packages = with pkgs; [
      zbar
      wl-clipboard
    ];
  };
}
