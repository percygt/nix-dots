{
  lib,
  username,
  config,
  pkgs,
  ...
}:
{
  options = {
    shell.system.enable = lib.mkEnableOption "Enable shells";
    shell.persist.enable = lib.mkOption {
      description = "Enable shell persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.shell.system.enable {
    environment.persistence = lib.mkIf config.shell.persist.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".local/share/fish" ];
        };
      };
    };
    programs.fish.enable = true;
    users.users.${username}.shell = pkgs.fish;
    environment.shells = with pkgs; [ fish ];
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
    };
  };
}
