{ lib, config, ... }:
let
  inherit (config.modules) app;
in
with lib;
{
  modules.fileSystem.persist.userData.directories = [
    (optionalString app.brave.enable ".config/BraveSoftware/Brave-Browser")
    (optionalString app.chromium.enable ".config/chromium")
    (optionalString app.zen.enable ".zen")
  ];
}
