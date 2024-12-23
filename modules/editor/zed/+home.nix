{
  config,
  lib,
  ...
}:
let
  g = config._base;
  f = config.modules.fonts.shell;
  cfg = config.modules.editor.zed;
  moduleZed = "${g.flakeDirectory}/modules/editor/zed";
in
{
  config = lib.mkIf config.modules.editor.zed.enable {
    home.packages = [ cfg.finalPackage ];
    xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleZed}/settings.jsonc";
    xdg.configFile."zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleZed}/keymap.json";
  };
}
