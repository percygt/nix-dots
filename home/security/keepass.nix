{pkgs, ...}: let
  kmk0 =
    if (builtins.pathExists "/data/keeps/m0.kdbx")
    then "/data/keeps/m0.kdbx"
    else "";
in {
  home.packages = with pkgs; [
    keepassxc
  ];
  home.sessionVariables.KPDB = kmk0;
}
