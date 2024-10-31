{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
in
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${g.username} = {
        directories = [ ".local/share/fish" ];
      };
    };
  };
  programs.fish.enable = true;
  users.users.${g.username}.shell = pkgs.fish;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [
    fish
    bash
  ];
}
