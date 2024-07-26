{
  lib,
  username,
  config,
  ...
}:
let
  cfg = config.modules.shell;
  sh = cfg.userDefaultShell;
in
{
  options.modules.shell = {
    enable = lib.mkOption {
      description = "Enable shell packages";
      default = true;
      type = lib.types.bool;
    };
    userDefaultShell = lib.mkOption {
      description = "User default shell";
      default = "fish";
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".local/share/fish" ];
        };
      };
    };
    programs.${sh}.enable = true;
    users.users.${username}.shell = config.programs.${sh}.package;
    users.defaultUserShell = config.programs.${sh}.package;
    environment.shells = [ config.programs.${sh}.package ];
    home-manager.users.${username} = import ./home.nix;
  };
}
