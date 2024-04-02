{
  pkgs,
  config,
  flakeDirectory,
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
    shellAliases = {
      hms = "home-manager switch --flake ${flakeDirectory}#$HOSTNAME";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
      ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
    };
  };
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
    groups.percygt.members = ["percygt"];
    users.percygt = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.user-hashedPassword.path;
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