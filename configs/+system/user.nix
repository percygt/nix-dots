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
  sops.secrets.userHashedPassword.neededForUsers = true;

  users = {
    defaultUserShell = g.shell.default.package;
    mutableUsers = false;
    users.${username} = {
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
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
