{ lib, ... }:
{
  options.modules.app.librewolf.enable = lib.mkEnableOption "Enable librewolf";
}
