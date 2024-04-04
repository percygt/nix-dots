{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.userModules.git.credentials.enable {
    sops.secrets."git/credentials" = {
      path = "${config.xdg.configHome}/git/credentials";
    };
  };
}
