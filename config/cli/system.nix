{
  lib,
  pkgs,
  config,
  ...
}:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = import ./home.nix;
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist".users.${g.username}.directories = [
      ".local/share/tmux"
      ".local/share/navi"
      ".local/share/zoxide"
    ];
  };
  systemd.user.services.tmux = {
    enable = true;
    description = "tmux server";
    serviceConfig = {
      Type = "forking";
      Restart = "always";
      ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment} ; exec ${pkgs.tmux}/bin/tmux start-server'";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
    };
    wantedBy = [ "default.target" ];
  };
}
