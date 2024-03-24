{
  pkgs,
  config,
  ...
}: let
  kmk0 = "${config.home.homeDirectory}/data/keeps/m0.kdbx";
in {
  home.packages = with pkgs; [
    keepassxc
  ];
  home.sessionVariables.KPDB = kmk0;
}
