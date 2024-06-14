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
            ".vscode-oss"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      cli.home = {
        atuin.enable = lib.mkDefault true;
        direnv.enable = lib.mkDefault true;
        extra.enable = lib.mkDefault true;
        starship.enable = lib.mkDefault true;
        aria.enable = lib.mkDefault true;
        ncmpcpp.enable = lib.mkDefault true;
        tui.enable = lib.mkDefault true;
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
