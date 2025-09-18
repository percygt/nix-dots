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
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  editorModules = "${g.flakeDirectory}/modules/editor";
  moduleEmacs = "${editorModules}/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EMACSDIR = "${config.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
  # capture = pkgs.writers.writePython3 "capture" { doCheck = false; } (builtins.readFile ./capture.py);
  capture = "python $DOOMDIR/capture.py";
  doomconfig = pkgs.writers.writeBash "doomconfig" ''
    footclient --app-id doom-config --title Emacs -- emacsclient -t -a "" ${moduleEmacs}/doom/config.el
  '';
  emacsnotes = pkgs.writers.writeBash "emacsnotes" ''
    footclient --app-id notes --title Emacs -- emacsclient -t -a "" ${g.orgDirectory}/Inbox.org
  '';
  emacscapture = pkgs.writers.writeBash "emacscapture" ''
    footclient --app-id capture --title Emacs -- emacsclient -t -a "" --eval '(+org-capture/quick-capture)'
  '';
  emacsagenda = pkgs.writers.writeBash "emacsagenda" ''
    footclient --app-id agenda --title Emacs -- emacsclient -t -a "" --eval '(progn (org-agenda nil "m"))'
  '';
  termVar = "TERM=foot";
  termInfoVar = "TERMINFO=${config.modules.terminal.foot.package.terminfo}/share/terminfo";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway.config.startup = [
      {
        command = lib.concatStringsSep " " [
          termVar
          termInfoVar
          "${cfg.finalPackage}/bin/emacs --fg-daemon"
        ];
        always = true;
      }
    ];
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+n" = "exec ddapp -t 'notes' -- ${emacsnotes}";
      "${mod}+Shift+e" = "exec ddapp -t 'doom-config' -- ${doomconfig}";
      # "${mod}+y" = "exec ddapp -t 'clipboard-capture' -h 90 -w 90 -- ${clipboardcapture}";
      # "${mod}+Shift+y" =
      #   "exec ddapp -t 'clipboard-capture-interest' -h 90 -w 90 -- '${clipboardcapture} i'";
      "${mod}+e" = "exec ddapp -t 'agenda' -k true -- ${emacsagenda}";
      "${mod}+c" = "exec ddapp -t 'org-capture' -h 90 -w 90 -- '${capture} -w org-capture'";
      "${mod}+q" = "exec ddapp -t 'capture' -h 90 -w 90 -- ${emacscapture}";
    };
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
        "doom/autoload".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/autoload";
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
