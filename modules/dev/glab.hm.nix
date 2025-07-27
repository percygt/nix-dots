{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.dev.glab.enable {
    home.packages = [ pkgs.glab ];
    sops.secrets = {
      "git/glab-cli/config.yml" = {
        path = "${config.xdg.configHome}/glab-cli/config.yml";
        mode = "0600";
      };
    };
  };
}
