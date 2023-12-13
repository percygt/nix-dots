# {
#   pkgs,
#   inputs,
#   ...
# }:
#  let
#   xterm = pkgs.writeShellScriptBin "xterm" ''
#     ${pkgs.wezterm}/bin/wezterm "$@"
#   '';
# in
{
  # home.packages = [
  #   pkgs.stable.wezterm
  #   xterm
  # ];
  xdg.configFile.wezterm.source = ../../common/wezterm;
}
