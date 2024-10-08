{
  config,
  lib,
  pkgs,
  ...
}:
let
  g = config._general;
  moduleEmacs = "${g.flakeDirectory}/modules/editor/emacs";
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    xdg = {
      configFile = {
        "emacs/private.el".text = g.editor.emacs."private.el";
        "emacs/config".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config";
        "emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/early-init.el";
        "emacs/custom.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/custom.el";
        "emacs/common.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/common.el";
        "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
        "emacs/xemacs_color.svg".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/egstatsml/emacs_fancy_logos/refs/heads/main/xemacs_color.svg";
          sha256 = "02mql7z5dxgqjkqazjrlhb940sjdv5qg8p0d2v0y5a3aqhl86asq";
        };
      };
    };
  };
}
