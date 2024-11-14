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
  modules.core.persist.userData = {
    directories = [
      ".local/share/fish"
      ".local/share/nushell"
    ];
    files = [ ".config/nushell/history.txt" ];
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
