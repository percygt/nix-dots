{
  lib,
  username,
  config,
  ...
}:
let
  inherit (config.modules) app;
in
with lib;
{
  services.flatpak.enable = true;
  users.users.${username}.extraGroups = [ "flatpak" ];
  persistHome.directories = [
    (optionalString app.brave.enable ".config/BraveSoftware/Brave-Browser")
    (optionalString app.chromium.enable ".config/chromium")
    (optionalString app.zen.enable ".zen")
  ];
}
