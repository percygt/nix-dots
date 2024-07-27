{
  inputs,
  lib,
  desktop,
  ...
}:
{
  imports = [ inputs.xremap.nixosModules.default ];
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
}
