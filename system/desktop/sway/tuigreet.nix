{
  pkgs,
  config,
  lib,
  ...
}: let
  unsupported-gpu = lib.elem "nvidia" config.services.xserver.videoDrivers;
  sway-run = pkgs.writeShellScriptBin "sway-run" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    systemd-cat -t xsession sway ${lib.optionalString unsupported-gpu "--unsupported-gpu"}
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --remember-user-session";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sway-run
    pciutils
  ];

  environment.etc."greetd/environments".text = ''
    sway-run
    fish
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
