{
  lib,
  config,
  inputs,
  desktop,
  ...
}:
{
  imports = [ inputs.xremap.homeManagerModules.default ];

  services.xremap = {
    withGnome = lib.mkIf (desktop == "gnome") true;
    withWlroots = lib.mkIf (desktop == "sway") true;
    config.modmap = [
      {
        name = "Global";
        remap = {
          "CAPSLOCK" = {
            held = [ "CONTROL_L" ];
            alone = [ "ESC" ];
            alone_timeout_millis = 150;
          };
        };
      }
    ];
  };
  home = {
    activation.setupXremap = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/systemctl start --user xremap
    '';
  };
}
