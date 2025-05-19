{
  pkgs,
  config,
  username,
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
