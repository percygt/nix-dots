{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;

  emacsConfig = pkgs.concatTextFile {
    name = "config.el";
    files = map (dir: ./config/${dir}) (builtins.attrNames (builtins.readDir ./config));
  };

  extraPackages = import ./extraPackages.nix { inherit pkgs; };

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    alwaysEnsure = true;
    config = builtins.readFile emacsConfig;
    extraEmacsPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ] ++ extraPackages;
  };

  emacsWithExtraPackages = pkgs.runCommand "emacs" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    makeWrapper ${emacs}/bin/emacsclient $out/bin/emacsclient --prefix PATH : ${lib.makeBinPath extraPackages}
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPackages}
  '';
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home-manager.users.${g.username} = import ./home.nix;
    environment.systemPackages = [ emacsWithExtraPackages ];
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
