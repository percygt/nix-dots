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
    groups.percygt.members = ["percygt"];
    mutableUsers = false;
    users.percygt = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
      shell = pkgs.fish;
      extraGroups =
        [
          "audio"
          "networkmanager"
          "users"
          "video"
          "wheel"
          "input"
        ]
        ++ ifExists [
          "docker"
          "git"
          "kvm"
          "libvirt"
        ];
    };
  };
}
