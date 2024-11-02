{
  lib,
  config,
  username,
  ...
}:
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist".users.${username}.directories = [
      ".local/share/tmux"
      ".local/share/navi"
      ".local/share/zoxide"
    ];
  };
}
