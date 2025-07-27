{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.desktop.sway;
  unsupported-gpu = lib.elem "nvidia" config.services.xserver.videoDrivers;
  xSessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
  wlSessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in
{
  services.greetd = {
    enable = true;
    settings = {
      vt = 2;
      initial_session = {
        command = "${lib.getExe cfg.finalPackage} ${lib.optionalString unsupported-gpu "--unsupported-gpu"}";
        user = username;
      };
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --asterisks \
        --sessions ${xSessions}:${wlSessions} \
        --remember \
        --remember-user-session
        --cmd '${lib.getExe cfg.finalPackage} ${lib.optionalString unsupported-gpu "--unsupported-gpu"}'
      '';
    };
  };

  modules.fileSystem.persist.systemData.directories = [
    {
      directory = "/var/cache/tuigreet";
      user = "greeter";
      group = "greeter";
      mode = "0755";
    }
  ];
  environment.etc."greetd/environments".text = ''
    sway
    fish
    bash
  '';

  security.pam.services.greetd.enableGnomeKeyring = true;

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
