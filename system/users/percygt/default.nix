{
  pkgs,
  config,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
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
      extraGroups =
        [
          "audio"
          "users"
          "video"
          "wheel"
          "input"
        ]
        ++ ifExists [
          "networkmanager"
          "docker"
          "git"
          "kvm"
          "libvirt"
        ];
    };
  };
}
