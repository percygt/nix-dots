{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EMACSDIR = "${config.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  doomconfig = pkgs.writers.writeBash "doomconfig" ''
    emacsclient -F '((name . "DoomConfig"))' -c ${config.xdg.configHome}/doom;
  '';
  orgnote = pkgs.writers.writeBash "orgnote" ''
    emacsclient -c -e '(org-roam-node-find)' -F '((name . "Notes"))' 
  '';
in
{
  imports = [ ./module.nix ];
  config = lib.mkMerge [
    (lib.mkIf (swayCfg.enable && cfg.enable) {
      wayland.windowManager.sway.config = {
        keybindings = {
          "${mod}+e" = "exec ddapp -p '[app_id=emacs title=^Notes$]' -c ${orgnote}";
          "${mod}+Shift+e" = "exec ddapp -p '[app_id=emacs title=^DoomConfig$]' -c ${doomconfig}";
        };
      };
    })
    (lib.mkIf cfg.enable {
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
        # activation = {
        #   linkEmacsModule = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        #     [ -e "${config.xdg.configHome}/doom/modules" ] && cp -rs ${moduleEmacs}/doom/modules/. ${config.xdg.configHome}/doom/modules/
        #   '';
        # };
      };
      xdg = {
        configFile = {
          emacs.source = inputs.doom-emacs;
          "doom/private.el".text = g.editor.emacs."private.el";
          "doom/config.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/config.el";
          "doom/custom.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/custom.el";
          "doom/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/init.el";
          "doom/packages.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/packages.el";
          "doom/modules".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom/modules";
          "doom/nix.el".text = ''
            ;;; nixos.el --- Nixos stuff -*- lexical-binding: t -*-
            ;;; Commentary:
            ;;; Code:
            (add-to-list 'treesit-extra-load-path "${cfg.package.pkgs.treesit-grammars.with-all-grammars}/lib")
            (provide 'nix)
          '';
        };
      };
    })
  ];
}
