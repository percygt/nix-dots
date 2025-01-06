{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  g = config._base;
  cfg = config.modules.editor.emacs;
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EMACSDIR = "${config.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
  clipboardcapture = pkgs.writers.writeBash "clipboardcapture" ''
    url_check='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
    clipboard=$(wl-paste 2>/dev/null)
    if [[ $clipboard =~ $url_check ]]; then
      if [[ $1 = "i" ]]; then
        interest=$(printf 'Webpage\nVideo\nRepo\nArticle' | tofi -c ${config.xdg.configHome}/tofi/config-mid --prompt-text "Templates: ")
        case $interest in
        Webpage)
          template="iw"
          ;;
        Video)
          template="iv"
          ;;
        Repo)
          template="ir"
          ;;
        Article)
          template="ia"
          ;;
        esac
        footclient -t foot-direct --app-id clipboard-capture-interest --title Emacs -- emacsclient -t -a "" "org-protocol://capture?url=$clipboard&template=$template"
      else
        footclient -t foot-direct --app-id clipboard-capture --title Emacs -- emacsclient -t -a "" "org-protocol://capture?url=$clipboard&template=tu"
      fi
    else
      if [[ $1 = "i" ]]; then
        interest=$(printf 'Book\nInformation\nIdea' | tofi -c ${config.xdg.configHome}/tofi/config-mid --prompt-text "Templates: ")
        case $interest in
        Book)
          template="ib"
          ;;
        Information)
          template="ii"
          ;;
        Idea)
          template="iI"
          ;;
        esac
        footclient -t foot-direct --app-id clipboard-capture-interest --title Emacs -- emacsclient -t -a "" "org-protocol://capture?body=$clipboard&template=$template"
      else
        footclient -t foot-direct --app-id clipboard-capture --title Emacs -- emacsclient -t -a "" "org-protocol://capture?body=$clipboard&template=tc"
      fi
    fi
  '';
  doomconfig = pkgs.writers.writeBash "doomconfig" ''
    footclient -t foot-direct --app-id doom-config --title Emacs -- emacs -nw ${moduleEmacs}/doom
  '';
  emacsnotes = pkgs.writers.writeBash "emacsnotes" ''
    footclient -t foot-direct --app-id notes --title Emacs -- emacs -nw ${g.orgDirectory}/Inbox.org
  '';
  emacscapture = pkgs.writers.writeBash "emacscapture" ''
    footclient -t foot-direct --app-id capture --title Emacs -- emacsclient -t -a "" --eval '(progn (org-capture))'
  '';
  emacsagenda = pkgs.writers.writeBash "emacsagenda" ''
    footclient -t foot-direct --app-id agenda --title Emacs -- emacsclient -t -a "" --eval '(progn (org-agenda nil "m"))'
  '';
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway.config.startup = [
      {
        command = "emacs --daemon";
        always = true;
      }
    ];
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+n" = "exec ddapp -t 'notes' -c ${emacsnotes}";
      "${mod}+Shift+e" = "exec ddapp -t 'doom-config' -c ${doomconfig}";
      "${mod}+y" = "exec ddapp -t 'clipboard-capture' -m false -h 90 -w 90 -c ${clipboardcapture}";
      "${mod}+Shift+y" = "exec ddapp -t 'clipboard-capture-interest' -m false -h 90 -w 90 -c '${clipboardcapture} i'";
      "${mod}+e" = "exec ddapp -t 'agenda' -k true -c ${emacsagenda}";
      "${mod}+c" = "exec ddapp -t 'capture' -m false -h 90 -w 90 -c ${emacscapture}";
    };
    home = {
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
