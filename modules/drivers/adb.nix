{
  username,
  lib,
  config,
  ...
}: {
  options = {
    drivers.adb = {
      enable =
        lib.mkEnableOption "Enable adb";
    };
  };

  config = lib.mkIf config.drivers.adb.enable {
    programs.adb.enable = true;
    users.users.${username} = {
      extraGroups = ["adbusers"];
    };
  };
}
