{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  g = config._base;
  t = config.modules.themes;
  c = t.colors.withHashtag;
  cfg = config.modules.editor.emacs;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EMACSDIR = "${config.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  doomconfig = pkgs.writers.writeBash "doomconfig" ''
    emacs ${moduleEmacs}/doom -T "Doom Config"
  '';
  emacscapture = pkgs.writers.writeBash "emacscapture" ''
    cleanup() {
      emacsclient --eval '(let (kill-emacs-hook) (kill-emacs))'
    }

    # If emacs isn't running, we start a temporary daemon, solely for this window.
    if ! emacsclient --suppress-output --eval nil 2>/dev/null; then
      echo "No Emacs daemon/server is available! Starting one..."
      emacs --daemon="capture"
      trap cleanup EXIT INT TERM
    fi
    if [ -z "$1" ]; then
      url=$( echo | dmenu -p "Enter URL:" )
    else
      url="$1"
    fi

    emacsclient -s "capture" -F "(quote (name . \"capture\"))" --no-wait -e "(+aiz-org-capture-frame)"
  '';
  emacsnotes = pkgs.writers.writeBash "emacsnotes" ''
    emacs ${g.orgDirectory}/Inbox.org  -T "Notes"
  '';
  emacsagenda = pkgs.writers.writeBash "emacsagenda" ''
    emacs --eval "(progn (org-agenda nil \"m\"))" -T "Agenda"
  '';
in
{
  config = lib.mkIf cfg.enable {
    # wayland.windowManager.sway.config.startup = [
    #   {
    #     command = "emacs --daemon=\"capture\"";
    #     always = true;
    #   }
    # ];
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+n" = "exec ddapp -t 'emacs' -n 'Notes' -c ${emacsnotes}";
      "${mod}+Shift+e" = "exec ddapp -t 'emacs' -n 'Doom.' -c ${doomconfig}";
      "${mod}+c" = "exec ddapp -t 'emacs' -n 'Org.' -c ${emacscapture}";
      "${mod}+e" = "exec ddapp -t 'emacs' -n 'Agenda' -c ${emacsagenda}";
    };
    home = {
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
        "doom/configs".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/configs";
        "doom/autoload".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/autoload";
        "doom/private.el".text = g.editor.emacs."private.el";
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
