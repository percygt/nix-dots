{ username, config, ... }:
{
  users.users.${username}.extraGroups = [
    config.users.groups.ydotool.name
  ];
  programs.ydotool.enable = true;
}
