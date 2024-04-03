{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.userModules.git.credentials.enable {
    sops.secrets."git/credentials" = {
      path = "${config.home.homeDirectory}/.config/git/credentials";
    };
  };
}
