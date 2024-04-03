{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.userModules.git.glab.enable {
    home.packages = with pkgs; [
      glab
    ];
    sops.secrets = {
      "glab-cli/config.yml" = {
        path = "${config.xdg.configHome}/glab-cli/config.yml";
      };
    };
  };
}
