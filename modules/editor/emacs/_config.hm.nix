{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  g = config._global;
  cfg = config.modules.editor.emacs;
  editorModules = "${g.flakeDirectory}/modules/editor";
  moduleEmacs = "${editorModules}/emacs";
  DOOMLOCALDIR = "${g.xdg.dataHome}/doom";
  DOOMDIR = "${g.xdg.configHome}/doom";
  EMACSDIR = "${g.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${g.xdg.dataHome}/doom/cache/profile-load.el";
in
{
  config = lib.mkIf cfg.enable {
    programs.niri.settings =
      let
        termVar = "TERM=foot";
        termInfoVar = "TERMINFO=${config.modules.terminal.foot.package.terminfo}/share/terminfo";
        inherit (config.modules.editor) emacs;
      in
      {
        spawn-at-startup = [
          {
            command = [
              termVar
              termInfoVar
              "${emacs.finalPackage}/bin/emacs --fg-daemon"
            ];
          }
        ];
        binds =
          with config.lib.niri.actions;
          let
            editorModules = "${g.flakeDirectory}/modules/editor";
            moduleEmacs = "${editorModules}/emacs";
            doomconfig = pkgs.writers.writeBash "doomconfig" ''
              emacsclient -t -a "" ${moduleEmacs}/doom/config.el
            '';
            emacsnotes = pkgs.writers.writeBash "emacsnotes" ''
              emacsclient -t -a "" ${g.orgDirectory}/Inbox.org
            '';
            emacscapture = pkgs.writers.writeBash "emacscapture" ''
              emacsclient -t -a "" --eval '(+org-capture/quick-capture)'
            '';
            emacsagenda = pkgs.writers.writeBash "emacsagenda" ''
              emacsclient -t -a "" --eval '(progn (org-agenda nil "m"))'
            '';
          in
          {
            "Mod+Shift+E".action = spawn "footpad" "--term=foot-direct" "--app-id=doom" "--" "${doomconfig}";
            "Mod+N".action = spawn "footpad" "--term=foot-direct" "--app-id=notes" "--" "${emacsnotes}";
            # "Mod+E".action = spawn "footpad" "--term=foot-direct" "--app-id=agenda" "--" "${emacsagenda}";
            "Mod+E".action = spawn "footpad" "--term=foot-direct" "--app-id=agenda" "--" "${emacsagenda}";
            "Mod+Alt+C".action = spawn "footpad" "--term=foot-direct" "--app-id=capture" "--" "${emacscapture}";
            "Mod+C".action =
              spawn "footpad" "--term=foot-direct" "--app-id=org-capture" "--" "python" "${DOOMDIR}/capture.py"
                "-w"
                "org-capture";
          };
      };
    # services.emacs = {
    #   enable = true;
    #   package = cfg.finalPackage;
    # };
    home = {
      packages = [ cfg.finalPackage ];
      shellAliases.e = "emacs -nw";
      shellAliases = {
        doom-install = "${EMACSDIR}/bin/doom install --no-env --no-hooks";
        doom-update = "${EMACSDIR}/bin/doom sync -u";
      };
      sessionPath = [ "${EMACSDIR}/bin" ];
      sessionVariables = {
        inherit
          EMACSDIR
          DOOMLOCALDIR
          DOOMDIR
          DOOMPROFILELOADFILE
          ;
      };
    };
    xdg = {
      configFile = {
        emacs.source = inputs.doom-emacs;
        "doom/config.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/config.el";
        "doom/custom.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/custom.el";
        "doom/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/init.el";
        "doom/packages.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/packages.el";
        "doom/modules".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/modules";
        "doom/snippets".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/snippets";
        # "doom/autoload".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/autoload";
        "doom/configs".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/configs";
        "doom/capture.py".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/capture.py";
        "doom/system.el".text = g.textEditor.emacs."system.el";
        "doom/nix.el".text =
          # lisp
          ''
            ;;; nix.el --- Nixos stuff -*- lexical-binding: t -*-
            ;;; Commentary:
            ;;; Code:

            ;; treesit grammars path
            (add-to-list 'treesit-extra-load-path "${cfg.package.pkgs.treesit-grammars.with-all-grammars}/lib")

            ;; Dirvish quickacces directories
            (require 'dirvish)
            (setq dirvish-quick-access-entries
                   `(("o" "${g.orgDirectory}"                         "Org")
                     ("n" "${g.orgDirectory}/notes"                   "Notes")
                     ("c" "${g.flakeDirectory}/modules/editor/emacs"  "Emacs Config")
                     ("f" "${g.flakeDirectory}"                       "Flake Directory")
                     ("s" "${g.secretsDirectory}"                     "Secrets Directory")
                     ("d" "${g.dataDirectory}"                        "Data directory")
                     ))

            (provide 'nix)
            ;;; nix.el ends here
          '';
      };
    };
  };
}
