{
  pkgs,
  config,
  ...
}: {
  shell.system.enable = true;

  environment.sessionVariables.EDITOR = "vim";

  sops.secrets.userHashedPassword.neededForUsers = true;

  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
    users.percygt = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
      packages = [pkgs.home-manager];
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
