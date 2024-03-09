{
  username,
  ...
}: {
  # greetd display manager
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

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
