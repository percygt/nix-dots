{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.percygt.git.enable {
    sops.secrets."git/credentials" = {
      path = "${config.home.homeDirectory}/.config/git/credentials";
    };
  };
}
