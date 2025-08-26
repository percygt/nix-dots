{
  username,
  lib,
  config,
  ...
}:
{

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = username;
    };
    greetd =
      let
        session = {
          command = "${lib.getExe' config.modules.desktop.niri.package "niri-session"}";
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
}
