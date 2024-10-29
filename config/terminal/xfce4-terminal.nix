{ config, pkgs, ... }:
let
  t = config.modules.theme;
  c = t.colors.withHashtag;
  f = config.modules.fonts.shell;
in
{
  home.packages = [ pkgs.xfce.xfce4-terminal ];
}
