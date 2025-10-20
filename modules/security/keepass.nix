{
  config,
  lib,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.security.keepass.enable {
    persistHome.directories = [ ".config/keepassxc" ];
    users.users.${username}.extraGroups = [
      config.users.groups.ydotool.name
    ];
    programs.ydotool.enable = true;
  };
}
