{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
  defaultShell = g.defaultShell;
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
  programs.${defaultShell}.enable = true;
  users.users.${g.username}.shell = pkgs.${defaultShell};
  users.defaultUserShell = pkgs.${defaultShell};
  environment.shells = with pkgs; [
    fish
    bash
  ];
}
