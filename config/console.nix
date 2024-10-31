{
  config,
  pkgs,
  ...
}:
let
  c = config.modules.theme.colors;
in
{
  console = {
    earlySetup = true;
    colors = c.toList;
    packages = with pkgs; [
      terminus_font
      powerline-fonts
    ];
    font = "ter-powerline-v32n";
  };
}
