{
  config,
  ...
}:
let
  g = config._base;
  inherit (config.modules.themes)
    cursorTheme
    ;
  screenshotsDir = config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR;
in
{
  programs.niri.settings = {
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
    overview = {
      workspace-shadow.enable = false;
      backdrop-color = "#0f0f0f";
    };
    gestures = {
      hot-corners.enable = true;
    };
    cursor = {
      inherit (cursorTheme) size;
      theme = "${cursorTheme.name}";
    };
    screenshot-path = screenshotsDir + "/%Y-%m-%d-%H%M%S.png";
    environment = g.system.envVars // {
      DISPLAY = null;
    };
  };
}
