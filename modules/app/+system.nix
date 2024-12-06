{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.app;
in
{

  modules.core.persist.userData.directories = [
    (lib.optionalString cfg.zen-browser.enable ".zen")
  ];
}
