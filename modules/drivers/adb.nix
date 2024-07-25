{
  username,
  lib,
  config,
  ...
}:
{
  options.modules.drivers.adb.enable = lib.mkEnableOption "Enable adb";

  config = lib.mkIf config.modules.drivers.adb.enable {
    programs.adb.enable = true;
    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
