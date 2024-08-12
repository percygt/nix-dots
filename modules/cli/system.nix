{ lib, config, ... }:
let
  g = config._general;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.dev.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${g.username}.directories = [
        ".local/share/atuin"
        ".local/share/aria2"
      ];
    };
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.cli.enable = lib.mkDefault true;
    };
  };
}
