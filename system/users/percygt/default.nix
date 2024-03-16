{
  pkgs,
  config,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.percygt = {
    isNormalUser = true;
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
  # This is a workaround for not seemingly being able to set $EDITOR in home-manager
  environment.sessionVariables = {
    EDITOR = "vim";
  };
}
