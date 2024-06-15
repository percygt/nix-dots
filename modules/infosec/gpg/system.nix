{
  username,
  lib,
  config,
  ...
}: {
  options.infosec.gpg.system.enable = lib.mkEnableOption "Enable gpg";
  config = lib.mkIf config.infosec.gpg.system.enable {
    environment.persistence = lib.mkIf config.core.ephemeral.enable {
      "/persist".users.${username}.directories = [
        {
          directory = ".local/share/gnupg";
          mode = "0700";
        }
      ];
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      infosec.gpg.home.enable = lib.mkDefault true;
      infosec.gpg.pass.enable = lib.mkDefault true;
    };
  };
}
