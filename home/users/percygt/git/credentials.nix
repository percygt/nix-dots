{config, ...}: {
  sops.secrets."git/credentials" = {
    path = "${config.home.homeDirectory}/.config/git/credentials";
  };
}
