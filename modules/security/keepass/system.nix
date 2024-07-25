{
  config,
  lib,
  username,
  ...
}:
{
  options.modules.security.keepass.enable = lib.mkEnableOption "Enable sops";
  config = lib.mkIf config.modules.security.sops.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".config/keepassxc" ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.security.keepass.enable = lib.mkDefault true;
    };
  };
}
