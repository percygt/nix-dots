{ lib, ... }:
{
  options.modules.app = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
    zen.enable = lib.mkEnableOption "Enable zen";
  };
}
