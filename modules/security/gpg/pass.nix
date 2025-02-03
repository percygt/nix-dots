{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  PASSWORD_STORE_DIR = g.security.gpg.passDir;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
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
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+Ctrl+KP_Multiply" = "exec pkill tofi || ${lib.getExe pkgs.tofi-pass}";
      };
    };
  };
}
