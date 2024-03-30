{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.userModules.git.enable {
    sops.secrets."git/credentials" = {
      path = "${config.home.homeDirectory}/.config/git/credentials";
    };
  };
}
