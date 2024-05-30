{
  username,
  lib,
  config,
  ...
}: {
  options.infosec = {
    gpg = {
      enable = lib.mkEnableOption "Enable gpg";
    };
  };
  # configured in home
  config = lib.mkIf config.infosec.gpg.enable {
    home-manager.users.${username} = import ./home.nix;
    environment.persistence = {
      "/persist".users.${username}.directories = [
        {
          directory = ".local/share/gnupg";
          mode = "0700";
        }
      ];
    };
  };
}
