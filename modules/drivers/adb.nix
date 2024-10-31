{ lib, config, ... }:
let
  g = config._general;
in
{

  config = lib.mkIf config.modules.drivers.adb.enable {
    programs.adb.enable = true;
    users.users.${g.username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
