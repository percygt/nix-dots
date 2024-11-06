{
  lib,
  username,
  config,
  ...
}:
let
  g = config._base;
  defaultShell = g.shell.default.package;
in
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/fish"
          ".local/share/nushell"
          ".config/nushell"
        ];
      };
    };
  };
  programs.fish.enable = defaultShell == g.shell.fish.package;
  users.users.${username}.shell = defaultShell;
  users.defaultUserShell = defaultShell;
  environment = {
    shells = with g.shell; [
      nushell.package
      bash.package
      fish.package
    ];
  };
}
