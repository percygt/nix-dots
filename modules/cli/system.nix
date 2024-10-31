{ lib, config, ... }:
let
  g = config._general;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.cli.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${g.username}.directories = [
        ".local/share/atuin"
        ".local/share/aria2"
      ];
    };
  };
}
