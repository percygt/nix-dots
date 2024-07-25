{
  username,
  lib,
  config,
  ...
}:
{
  options.modules.cli.enable = lib.mkEnableOption "Enable all cli apps";
  config = lib.mkIf config.modules.cli.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/tmux/resurrect"
            ".local/share/aria2"
            ".local/share/atuin"
            ".local/share/zoxide"
            ".local/share/navi"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.cli = {
        atuin.enable = lib.mkDefault true;
        direnv.enable = lib.mkDefault true;
        extra.enable = lib.mkDefault true;
        starship.enable = lib.mkDefault true;
        aria.enable = lib.mkDefault true;
        ncmpcpp.enable = lib.mkDefault true;
        yazi.enable = lib.mkDefault true;
        common.enable = lib.mkDefault true;
        bat.enable = lib.mkDefault true;
        eza.enable = lib.mkDefault true;
        tmux.enable = lib.mkDefault true;
        nixtools.enable = lib.mkDefault true;
      };
    };
  };
}
