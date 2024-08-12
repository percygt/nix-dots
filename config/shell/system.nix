{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
  defaultShell = g.defaultShell.package;
in
{
  home-manager.users.${g.username} = import ./home.nix;
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${g.username} = {
        directories = [ ".local/share/fish" ];
      };
    };
  };
  users.users.${g.username}.shell = defaultShell;
  users.defaultUserShell = defaultShell;
  environment.shells = with pkgs; [
    fish
    bash
  ];
}
