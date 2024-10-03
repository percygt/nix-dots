{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.editor.emacs.enable = lib.mkDefault true;
    };
    environment.systemPackages = [
      cfg.finalPackage
      (pkgs.aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          en-science
          es
        ]
      ))
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
