{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [ ".local/share/fish" ];
      };
    };
  };
  programs.fish.enable = true;
  users.users.${username}.shell = pkgs.fish;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [
    fish
    bash
  ];
}
