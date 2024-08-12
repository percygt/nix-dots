{ lib, config, ... }:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = import ./home.nix;
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist".users.${g.username}.directories = [
      ".local/share/aria2"
      ".local/share/tmux"
      ".local/share/navi"
      ".local/share/zoxide"
    ];
  };
}
