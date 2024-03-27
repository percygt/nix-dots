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
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
    groups.percygt.members = ["percygt"];
    users.percygt = {
      isNormalUser = true;
      initialPassword = "noice";
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
          "kvm"
          "libvirt"
        ];

      packages = [pkgs.home-manager];
    };
  };
}
