{
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.cli.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${username}.directories = [
        ".local/share/atuin"
        ".local/share/aria2"
      ];
    };
  };
}
