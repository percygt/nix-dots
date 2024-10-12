{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  g = config._general;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home = {
      shellAliases.doom-rm-git = "rm -rf ~/.config/emacs/.local/straight/{repos,build-*}/json-snatcher";
      sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
      sessionVariables = {
        inherit DOOMLOCALDIR DOOMDIR DOOMPROFILELOADFILE;
      };
    };
    xdg = {
      configFile = {
        doom.source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/doom";
        emacs = {
          source = pkgs.applyPatches {
            name = "doom-emacs-source";
            src = inputs.doom-emacs;
            # No longer necessary since https://github.com/hlissner/doom-emacs/commit/1c1ad3a8c8b669b6fa20b174b2a4c23afa85ec24
            # Just pass "--no-hooks" when installing Doom Emacs
            # patches = [ ./doom.d/disable_install_hooks.patch ];
          };
          force = true;
        };
      };
      # configFile = {
      #   "emacs/private.el".text = g.editor.emacs."private.el";
      #   "emacs/config".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config";
      #   "emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/early-init.el";
      #   "emacs/custom.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/custom.el";
      #   "emacs/common.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/common.el";
      #   "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
      #   "emacs/xemacs_color.svg".source = pkgs.fetchurl {
      #     url = "https://raw.githubusercontent.com/egstatsml/emacs_fancy_logos/refs/heads/main/xemacs_color.svg";
      #     sha256 = "02mql7z5dxgqjkqazjrlhb940sjdv5qg8p0d2v0y5a3aqhl86asq";
      #   };
      # };
    };
  };
}
