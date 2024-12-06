{ lib, ... }:
{
  options.modules.app = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
    zen-browser.enable = lib.mkEnableOption "Enable zen-browser";
  };
}
