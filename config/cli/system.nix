{
  lib,
  config,
  ...
}:
let
  g = config._general;
in
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist".users.${g.username}.directories = [
      ".local/share/tmux"
      ".local/share/navi"
      ".local/share/zoxide"
    ];
  };
}
