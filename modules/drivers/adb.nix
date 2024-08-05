{ lib, config, ... }:
let
  g = config._general;
in
{
  options.modules.drivers.adb.enable = lib.mkEnableOption "Enable adb";

  config = lib.mkIf config.modules.drivers.adb.enable {
    programs.adb.enable = true;
    users.users.${g.username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
