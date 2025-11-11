{
  config,
  username,
  lib,
  ...
}:
let
  g = config._global;
in
{
  users = {
    defaultUserShell = g.shell.defaultPackage;
    mutableUsers = false;
    users.${username} = {
      uid = 1000;
      isNormalUser = true;
      initialPassword = lib.mkIf (config.users.users.${username}.hashedPasswordFile == null) "guest";
      extraGroups = [
        "audio"
        "storage"
        "users"
        "video"
        "wheel"
        "input"
        "git"
      ];
    };
  };
}
