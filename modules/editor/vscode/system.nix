{
  username,
  lib,
  config,
  ...
}:
{
  options.modules.editor.vscode.enable = lib.mkEnableOption "Enable vscode systemwide";
  config = lib.mkIf config.modules.editor.vscode.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".vscode-oss" ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.editor.vscode.enable = lib.mkDefault true;
    };
  };
}
