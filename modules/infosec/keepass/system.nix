{
  config,
  lib,
  username,
  ...
}: {
  options.infosec.keepass.system.enable = lib.mkEnableOption "Enable sops";
  config = lib.mkIf config.infosec.sops.system.enable {
    environment.persistence = lib.mkIf config.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".config/keepassxc"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      infosec.keepass.home.enable = lib.mkDefault true;
    };
  };
}
