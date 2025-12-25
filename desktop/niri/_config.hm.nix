{
  config,
  colorize,
  lib,
  libx,
  pkgs,
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
      configNiri = "${flakeDirectory}/desktop/niri";
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
      editorModules = "${g.flakeDirectory}/modules/editor";
      moduleEmacs = "${editorModules}/emacs";
      DOOMLOCALDIR = "${g.xdg.dataHome}/doom";
      DOOMDIR = "${g.xdg.configHome}/doom";
      EMACSDIR = "${g.xdg.configHome}/emacs";
      DOOMPROFILELOADFILE = "${g.xdg.dataHome}/doom/cache/profile-load.el";
      doomconfig = pkgs.writers.writeBash "doomconfig" ''
        emacsclient -t -a "" ${moduleEmacs}/doom/config.el
      '';
      emacsnotes = pkgs.writers.writeBash "emacsnotes" ''
        emacsclient -t -a "" ${g.orgDirectory}/Inbox.org
      '';
      emacscapture = pkgs.writers.writeBash "emacscapture" ''
        emacsclient -t -a "" --eval '(+org-capture/quick-capture)'
      '';
      emacsagenda = pkgs.writers.writeBash "emacsagenda" ''
        emacsclient -t -a "" --eval '(progn (org-agenda nil "m"))'
      '';
    in
    {
      "niri/config".source = symlink "${configNiri}/_config";
      "niri/config.kdl".source = symlink "${configNiri}/_config.kdl";
      "niri/nix.kdl".text =
        with libx.kdl;
        serialize.nodes [
          (lib.optionalString config.modules.virtualisation.waydroid.enable (
            leaf "spawn-at-startup" [
              "systemctl"
              "--user"
              "start"
              "waydroid-monitor.service"
            ]
          ))
          (lib.optionalString config.modules.editor.emacs.enable (
            leaf "spawn-at-startup" [
              "COLORTERM=truecolor"
              "TERMINFO=${config.modules.terminal.foot.package.terminfo}/share/terminfo"
              "${emacs.finalPackage}/bin/emacs --fg-daemon"
            ]
          ))
          (lib.optionalString config.modules.editor.emacs.enable (
            plain "binds" [
              (plain "Mod+Shift+E" [
                (leaf "spawn" [
                  "footpad"
                  "--term=foot-direct"
                  "--app-id=doom"
                  "--"
                  "${doomconfig}"
                ])
              ])
              (plain "Mod+N" [
                (leaf "spawn" [
                  "footpad"
                  "--term=foot-direct"
                  "--app-id=notes"
                  "--"
                  "${emacsnotes}"
                ])
              ])
              (plain "Mod+E" [
                (leaf "spawn" [
                  "footpad"
                  "--term=foot-direct"
                  "--app-id=agenda"
                  "--"
                  "${emacsagenda}"
                ])
              ])
              (plain "Mod+Alt+C" [
                (leaf "spawn" [
                  "footpad"
                  "--term=foot-direct"
                  "--app-id=capture"
                  "--"
                  "${emacscapture}"
                ])
              ])
              (plain "Mod+C" [
                (leaf "spawn" [
                  "footpad"
                  "--term=foot-direct"
                  "--app-id=org-capture"
                  "--"
                  "python"
                  "${DOOMDIR}/capture.py"
                  "-w"
                  "org-capture"
                ])
              ])
            ]
          ))
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
            (leaf "path" "${lib.getExe config.modules.desktop.niri.xwaylandPackage}")
          ])
          (leaf "screenshot-path" (screenshotsDir + "/%Y-%m-%d-%H%M%S.png"))
          (plain "overview" [
            (leaf "backdrop-color" (colorize.hex.lighten c.base00 0.05))
            (plain "workspace-shadow" [ (flag "off") ])
          ])
          (plain "environment" (lib.mapAttrsToList leaf g.system.envVars))
        ];
    };
}
