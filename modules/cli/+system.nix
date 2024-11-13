{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.cli.enable {
    modules.core.persist.userData.directories = [
      ".local/share/atuin"
      ".local/share/aria2"
    ];
  };
}
