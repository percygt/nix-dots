{ lib, config, ... }:
let
  g = config._general;
in
{
  options.modules.editor.vscode.enable = lib.mkEnableOption "Enable vscode systemwide";
  config = lib.mkIf config.modules.editor.vscode.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [ ".vscode" ];
        };
      };
    };
    home-manager.users.${g.username} = {
      # imports = [ ./home.nix ];
      modules.editor.vscode.enable = lib.mkDefault true;
    };
  };
}
