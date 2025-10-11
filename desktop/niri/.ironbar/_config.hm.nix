{
  config,
  inputs,
  ...
}:
let
  g = config._global;
  moduleIronbar = "${g.flakeDirectory}/desktop/niri/ironbar";
in
{
  imports = [ inputs.ironbar.homeManagerModules.default ];
  programs.ironbar = {
    enable = true;
    systemd = true;
    style = "";
    config = null;
  };
  xdg.configFile =
    let
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "ironbar/config.corn".source = symlink "${moduleIronbar}/config.corn";
      "ironbar/style.css".source = symlink "${moduleIronbar}/style.css";
      "ironbar/modules".source = symlink "${moduleIronbar}/modules";
      "ironbar/styles".source = symlink "${moduleIronbar}/styles";
    };
}
