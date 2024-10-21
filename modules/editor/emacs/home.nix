{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  g = config._general;
  t = config.modules.theme;
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
    emacsclient -F '((name . "DoomConfig"))' -c ${moduleEmacs}/doom;
  '';
  emacsqa = pkgs.writers.writeBash "emacsqa" ''
    emacsclient -c -e '(dirvish-quick-access)' -F '((name . "Emacs Quick Access"))' 
  '';
in
{
  imports = [ ./module.nix ];
  config = lib.mkMerge [
    (lib.mkIf (swayCfg.enable && cfg.enable) {
      wayland.windowManager.sway.config = {
        keybindings = {
          "${mod}+q" = "exec ddapp -p '[app_id=emacs title=^Emacs\sQuick\sAccess$]' -c ${emacsqa}";
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
          "doom/private.el".text = g.editor.emacs."private.el";
          "doom/nix.el".text = ''
            ;;; nix.el --- Nixos stuff -*- lexical-binding: t -*-
            ;;; Commentary:
            ;;; Code:

            ;; treesit grammars path
            (add-to-list 'treesit-extra-load-path "${cfg.package.pkgs.treesit-grammars.with-all-grammars}/lib")

            ;; Dirvish quickacces directories
            (after! dirvish
              (setq dirvish-quick-access-entries
                     `(("o" "${g.orgDirectory}"                         "Org")
                       ("n" "${g.orgDirectory}/notes"                   "Notes")
                       ("c" "${g.flakeDirectory}/modules/editor/emacs"  "Emacs Config")
                       ("f" "${g.flakeDirectory}"                       "Flake Directory")
                       ("s" "${g.secretsDirectory}"                     "Secrets Directory")
                       ("d" "${g.dataDirectory}"                        "Data directory")
                       )))

            (provide 'nix)
          '';
          "doom/themes/base16-syft-theme.el".text = ''
            ;; base16-syft-theme.el -- A base16 colorscheme

            ;;; Commentary:
            ;; Base16: (https://github.com/tinted-theming/home)

            ;;; Authors:
            ;; Scheme: percygt (github.com/percygt)
            ;; Template: PercyGT

            ;;; Code:

            (defvar base16-syft-theme-colors
              '(:base00 "${c.base00}"
                :base01 "${c.base01}"
                :base02 "${c.base02}"
                :base03 "${c.base03}"
                :base04 "${c.base04}"
                :base05 "${c.base05}"
                :base06 "${c.base06}"
                :base07 "${c.base07}"
                :base08 "${c.base08}"
                :base09 "${c.base09}"
                :base0A "${c.base0A}"
                :base0B "${c.base0B}"
                :base0C "${c.base0C}"
                :base0D "${c.base0D}"
                :base0E "${c.base0E}"
                :base0F "${c.base0F}")
              "All colors for Base16 Syft are defined here.")

            (provide 'base16-syft-theme)

            ;;; base16-syft-theme.el ends here
          '';
        };
      };
    })
  ];
}
