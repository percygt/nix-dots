{username, ...}: {
  # greetd display manager
  services.xserver.enable = true;
  services.greetd = let
    session = {
      command = "Hyprland";
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
  security.pam.services.greetd.enableGnomeKeyring = true;
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
