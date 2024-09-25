{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;
  editorScript = pkgs.writeShellScriptBin "emacseditor" ''
    if [ -z "$1" ]; then
      exec ${cfg.finalPackage}/bin/emacsclient --create-frame --alternate-editor ${cfg.finalPackage}/bin/emacs
    else
      exec ${cfg.finalPackage}/bin/emacsclient --alternate-editor ${cfg.finalPackage}/bin/emacs "$@"
    fi
  '';
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.editor.emacs.enable = lib.mkDefault true;
    };
    systemd.user.services.emacs = {
      description = "Emacs: the extensible, self-documenting text editor";
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.runtimeShell} -c 'source ${config.system.build.setEnvironment}; exec ${cfg.finalPackage}/bin/emacs --fg-daemon'";
        ExecStop = "${cfg.finalPackage}/bin/emacsclient --eval (kill-emacs)";
        Restart = "always";
      };
      unitConfig = {
        After = "graphical-session.target";
      };
      wantedBy = [ "graphical-session.target" ];
    };
    environment.systemPackages = [
      cfg.finalPackage
      cfg.editorScript
    ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [
            ".local/cache/emacs"
            ".local/share/emacs"
          ];
        };
      };
    };
  };
}
