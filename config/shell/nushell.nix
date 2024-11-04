{ config, ... }:
let
  g = config._base;
  nushellPkg = g.shell.nushell.package;
  configNu = "${g.flakeDirectory}/config/shell/+assets";
in
{

  xdg = {
    configFile = {
      "nushell/_config.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/config.nu";
      "nushell/_env.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/env.nu";
    };
  };
  programs.nushell = {
    enable = true;
    package = nushellPkg;
    envFile.text = ''
      source-env ${config.xdg.configHome}/nushell/_env.nu
    '';
    configFile.text = ''
      source ${config.xdg.configHome}/nushell/_config.nu
    '';
    inherit (config.home) shellAliases;
  };
}
