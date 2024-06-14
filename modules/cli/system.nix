{
  username,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.cli.system.enable {
    environment.persistence = lib.mkIf config.cli.persist.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/tmux/resurrect"
            ".local/share/aria2"
            ".local/share/atuin"
            ".local/share/zoxide"
            ".config/gh"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      cli = {
        atuin.home.enable = lib.mkDefault true;
        direnv.home.enable = lib.mkDefault true;
        extra.home.enable = lib.mkDefault true;
        starship.home.enable = lib.mkDefault true;
        aria.home.enable = lib.mkDefault true;
        ncmpcpp.home.enable = lib.mkDefault true;
        tui.home.enable = lib.mkDefault true;
        yazi.home.enable = lib.mkDefault true;
        common.home.enable = lib.mkDefault true;
        bat.home.enable = lib.mkDefault true;
        eza.home.enable = lib.mkDefault true;
        tmux.home.enable = lib.mkDefault true;
        nixtools.home.enable = lib.mkDefault true;
      };
    };
  };
}
