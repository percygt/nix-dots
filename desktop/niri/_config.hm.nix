{
  config,
  colorize,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  g = config._global;
  inherit (config.modules.themes)
    cursorTheme
    ;
  c = config.modules.themes.colors.withHashtag;
  h = colorize.hex;
  screenshotsDir = g.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR;
  inherit (g) flakeDirectory;
  inherit (config.modules.editor) emacs;
in
{
  xdg.configFile =
    let
      configNiri = "${flakeDirectory}/desktop/niri/_config";
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "niri/binds.kdl".source = symlink "${configNiri}/binds.kdl";
      "niri/animations.kdl".source = symlink "${configNiri}/animations.kdl";
      "niri/input.kdl".source = symlink "${configNiri}/input.kdl";
      "niri/outputs.kdl".source = symlink "${configNiri}/outputs.kdl";
      "niri/layout.kdl".source = symlink "${configNiri}/layout.kdl";
      "niri/rules.kdl".source = symlink "${configNiri}/rules.kdl";
      "niri/startup.kdl".source = symlink "${configNiri}/startup.kdl";
      "niri/workspaces.kdl".source = symlink "${configNiri}/workspaces.kdl";
      "niri/config.kdl".text =
        # kdl
        ''
          prefer-no-csd
          hotkey-overlay { skip-at-startup; }
          include "animations.kdl"
          include "binds.kdl"
          include "input.kdl"
          include "layout.kdl"
          include "rules.kdl"
          include "startup.kdl"
          include "workspaces.kdl"
          include "nix.kdl"
        '';
      "niri/nix.kdl".text =
        with inputs.niri.lib.kdl;
        serialize.nodes [
          (leaf "spawn-at-startup" [
            "TERM=foot"
            "TERMINFO=${config.modules.terminal.foot.package.terminfo}/share/terminfo"
            "${emacs.finalPackage}/bin/emacs --fg-daemon"
          ])
          (plain "layout" [
            (plain "border" [
              (flag "on")
              (leaf "width" 2)
              (leaf "active-color" (h.setAlpha c.magenta 0.2))
              (leaf "inactive-color" (h.setAlpha (h.darken c.magenta 0.2) 0.2))
            ])
          ])
          (plain "cursor" [
            (flag "hide-when-typing")
            (leaf "hide-after-inactive-ms" 1000)
            (leaf "xcursor-theme" cursorTheme.name)
            (leaf "xcursor-size" cursorTheme.size)
          ])
          (plain "xwayland-satellite" [
            (flag "on")
            (leaf "path" "${lib.getExe pkgs.xwayland-satellite}")
          ])
          (leaf "screenshot-path" (screenshotsDir + "/%Y-%m-%d-%H%M%S.png"))
          (plain "overview" [
            (leaf "backdrop-color" (colorize.hex.lighten c.base00 0.05))
            (plain "workspace-shadow" [ (flag "off") ])
          ])
          (plain "environment" (
            lib.mapAttrsToList leaf (
              g.system.envVars
              // {
                DISPLAY = null;
              }
            )
          ))
        ];
    };
}
