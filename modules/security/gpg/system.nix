{
  username,
  lib,
  config,
  ...
}:
{
  options.modules.security.gpg.enable = lib.mkEnableOption "Enable gpg";
  config = lib.mkIf config.modules.security.gpg.enable {
    # environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    #   "/persist".users.${username}.directories = [
    #     {
    #       directory = ".local/share/gnupg";
    #       mode = "0700";
    #     }
    #   ];
    # };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.security.gpg.enable = lib.mkDefault true;
      modules.security.gpg.pass.enable = lib.mkDefault true;
    };
  };
}
