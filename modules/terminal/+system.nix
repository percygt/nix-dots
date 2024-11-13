{
  lib,
  config,
  desktop,
  username,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf (config.modules.terminal.xfce4-terminal.enable && desktop != "xfce") {
      programs.xfconf.enable = true;
      environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
        "/persist" = {
          users.${username} = {
            directories = [
              ".config/xfce4/xfconf"
            ];
          };
        };
      };
    })
  ];
}
