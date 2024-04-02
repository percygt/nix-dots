{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.userModules.git.enable {
    home.packages = with pkgs; [
      glab
    ];
    sops.secrets = {
      "glab-cli/config.yml" = {
        path = "${config.home.homeDirectory}/.config/glab-cli/config.yml";
      };
    };
  };
}