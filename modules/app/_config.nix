{
  lib,
  config,
  ...
}:
let
  inherit (config.modules) app;
in
with lib;
{
  persistHome.directories = [
    (optionalString app.brave.enable ".config/BraveSoftware/Brave-Browser")
    (optionalString app.chromium.enable ".config/chromium")
    (optionalString app.zen.enable ".zen")
  ];
}
