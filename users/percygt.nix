{ pkgs, config, ... }:
{
  modules.shell.userDefaultShell = "fish";

  environment.sessionVariables.EDITOR = "vim";

  sops.secrets.userHashedPassword.neededForUsers = true;

  users = {
    mutableUsers = false;
    users.percygt = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
      packages = [ pkgs.home-manager ];
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
