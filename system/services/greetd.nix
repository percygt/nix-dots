{
  config,
  lib,
  username,
  ...
}: {
  # greetd display manager
  services.greetd = let
    session = {
      command = "${lib.getExe config.programs.hyprland.package}";
      user = username;
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
