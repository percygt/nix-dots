{
  config,
  lib,
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
      dataFile."emacs/var/packages/nursery-2024-09-07" = {
        source = builtins.fetchGit {
          url = "https://github.com/chrisbarrett/nursery";
          rev = "00a169c75b934a2eb42ea8620e8eebf34577d4ca";
        };
      };
      configFile = {
        "emacs/config".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config";
        "emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/early-init.el";
        "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
      };
    };
  };
}
