{
  username,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.editor.vscode.system.enable {
    environment.persistence = lib.mkIf config.editor.vscode.persist.enable {
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
      editor.vscode.home.enable = lib.mkDefault true;
    };
  };
}
