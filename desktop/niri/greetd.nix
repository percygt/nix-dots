{
  username,
  lib,
  config,
  pkgs,
  ...
}:
let
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  niri-session = lib.getExe' config.modules.desktop.niri.package "niri-session";
  cfg = config.modules.desktop.niri;
in
{

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = username;
      sessionPackages = [ cfg.package ];
    };
    greetd =
      let
        session = {
          command = toString (
            pkgs.writeShellScript "niri-wrapper" ''
              trap '${systemctl} --user stop niri.service; sleep 1' EXIT
              exec ${niri-session} >/dev/null
            ''
          );
          user = username;
        };
      in
      {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  environment.etc."greetd/environments".text = "niri";
}
