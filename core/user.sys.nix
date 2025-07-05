{
  pkgs,
  config,
  username,
  lib,
  ...
}:
let
  g = config._base;
in
{
  users = {
    defaultUserShell = g.shell.default.package;
    mutableUsers = false;
    users.${username} = {
      uid = 1000;
      isNormalUser = true;
      initialPassword = lib.mkIf (config.users.users.${username}.hashedPasswordFile == null) "guest";
      packages = [ pkgs.home-manager ];
      extraGroups = [
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
