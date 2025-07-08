{
  config,
  pkgs,
  lib,
  ...
}:
let
  gitsigning = config.modules.dev.gitsigning.enable;
in
{
  config = lib.mkIf (config.modules.dev.glab.enable && gitsigning) {
    home.packages = [ pkgs.glab ];
    sops.secrets = {
      "git/glab-cli/config.yml" = {
        path = "${config.xdg.configHome}/glab-cli/config.yml";
        mode = "0600";
      };
    };
  };
}
