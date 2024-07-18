{
  username,
  lib,
  config,
  ...
}:
{
  options.editor = {
    vscode.system.enable = lib.mkEnableOption "Enable vscode systemwide";
    vscode.persist.enable = lib.mkOption {
      description = "Enable vscode persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.editor.vscode.system.enable {
    environment.persistence = lib.mkIf config.editor.vscode.persist.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".vscode-oss" ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      editor.vscode.home.enable = lib.mkDefault true;
    };
  };
}
