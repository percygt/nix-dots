{
  config,
  pkgs,
  lib,
  ...
}:
let
  g = config._global;
in
{
  config = lib.mkIf config.modules.dev.glab.enable {
    home.packages = [ pkgs.glab ];
    sops.secrets = {
      "git/glab-cli/config.yml" = {
        path = "${g.xdg.configHome}/glab-cli/config.yml";
        mode = "0600";
      };
    };
  };
}
