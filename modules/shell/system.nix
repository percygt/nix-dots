{
  lib,
  username,
  config,
  pkgs,
  ...
}:
{
  options.modules.shell.enable = lib.mkEnableOption "Enable shells";
  config = lib.mkIf config.modules.shell.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".local/share/fish" ];
        };
      };
    };
    programs.fish.enable = true;
    users.users.${username}.shell = pkgs.fish;
    environment.shells = with pkgs; [ fish ];
    home-manager.users.${username} = import ./home.nix;
  };
}
