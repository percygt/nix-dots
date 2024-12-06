{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.modules.app.zen-browser.enable {
    home.packages = [
      # pkgs.zen-browser
      inputs.zen-browser.packages."${pkgs.system}".default
    ];
  };
}
