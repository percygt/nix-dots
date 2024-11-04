{
  lib,
  pkgs,
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
        directories = [ ".local/share/fish" ];
      };
    };
  };
  programs.fish.enable = defaultShell == pkgs.fish;
  users.users.${username}.shell = defaultShell;
  users.defaultUserShell = defaultShell;
  environment.shells = [
    pkgs.nushell
    pkgs.bash
    pkgs.fish
  ];
}
