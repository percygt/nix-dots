{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.security.gpg;
in
{
  config = lib.mkIf config.modules.security.gpg.enable {
    programs = {
      gpg = {
        enable = true;
        inherit (cfg) package;
      };
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = cfg.sshSupport.enable;
      pinentry.package = if config.gtk.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
    };
  };
}
