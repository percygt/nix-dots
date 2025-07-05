{
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.driver.adb.enable {
    programs.adb.enable = true;
    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
