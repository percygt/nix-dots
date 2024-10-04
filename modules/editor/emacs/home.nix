{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config._general) flakeDirectory;
  moduleEmacs = "${flakeDirectory}/modules/editor/emacs";
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    xdg = {
      dataFile = {
        "emacs/var/packages/nursery-2024-09-07" = {
          source = builtins.fetchGit {
            url = "https://github.com/chrisbarrett/nursery";
            rev = "00a169c75b934a2eb42ea8620e8eebf34577d4ca";
            shallow = true;
          };
        };
      };
      configFile = {
        "emacs/config".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config";
        "emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/early-init.el";
        "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
        "emacs/xemacs_color.png".source = pkgs.fetchurl {
          url = "https://github.com/egstatsml/emacs_fancy_logos/blob/main/xemacs_color.png";
          sha256 = "1vyvsivxrnbb86lxrwzaml4cakv410z6nx4d9mnvbs9fn22m67bp";
        };
      };
    };
  };
}
