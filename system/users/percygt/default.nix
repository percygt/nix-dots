{
  pkgs,
  config,
  ...
}: {
  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [fish];
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  sops.secrets.userHashedPassword.neededForUsers = true;

  users = {
    defaultUserShell = pkgs.fish;
    # groups.percygt.members = ["percygt"];
    # groups.percygt.gid = 1000;
    mutableUsers = false;
    users.percygt = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
      shell = pkgs.fish;
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
