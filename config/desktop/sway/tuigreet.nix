{
  pkgs,
  config,
  lib,
  ...
}:
let
  unsupported-gpu = lib.elem "nvidia" config.services.xserver.videoDrivers;
  xSessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
  wlSessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --sessions ${xSessions}:${wlSessions} \
          --remember \
          --remember-user-session
          --cmd sway ${lib.optionalString unsupported-gpu "--unsupported-gpu"}
        '';
        user = "greeter";
      };
    };
  };

  environment = {
    persistence."/persist/system".directories = [
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }
    ];
    etc."greetd/environments".text = ''
      sway
      fish
    '';
  };

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
