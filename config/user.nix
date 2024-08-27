{ pkgs, config, ... }:
let
  g = config._general;
in
{
  sops.secrets.userHashedPassword.neededForUsers = true;

  users = {
    mutableUsers = false;
    users.${g.username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
      packages = [ pkgs.home-manager ];
      extraGroups = [
        config.users.groups.ydotool.name
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
