{
  config,
  lib,
  inputs,
  ...
}:
let
  g = config._general;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EMACSDIR = "${config.xdg.configHome}/emacs";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home = {
      shellAliases = {
        doom-install = "${EMACSDIR}/bin/doom install --no-env --no-hooks";
        doom-update = "rm -rf ${DOOMLOCALDIR}/straight/{repos,build-*}/json-snatcher && ${EMACSDIR}/bin/doom sync -u";
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
        "doom/private.el".text = g.editor.emacs."private.el";
        "doom/config.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config.el";
        "doom/custom.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/custom.el";
        "doom/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
        "doom/packages.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/packages.el";
        "doom/modules".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/modules";
        emacs.source = inputs.doom-emacs;
      };
    };
  };
}
