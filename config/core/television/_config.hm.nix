{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._global;
  configTv = "${g.flakeDirectory}/config/core/television";
  tvPackage = pkgs.television;
in
{
  home.packages = [ tvPackage ];
  xdg.configFile = {
    "television/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${configTv}/config.toml";
    "television/cable".source = config.lib.file.mkOutOfStoreSymlink "${configTv}/cable";
  };
  programs.bash.initExtra = ''
    eval "$(${lib.getExe tvPackage} init bash)"
  '';
  programs.fish.interactiveShellInit = ''
    ${lib.getExe tvPackage} init fish | source
  '';
}
