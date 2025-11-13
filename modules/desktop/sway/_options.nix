{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.sway;
  criteriaModule = types.attrsOf (types.either types.str types.bool);
  windowCommandModule = types.submodule {
    options = {
      command = mkOption {
        type = types.str;
        description = "Swaywm command to execute.";
      };

      criterias = mkOption {
        type = types.listOf criteriaModule;
        default = [ ];
        description = ''
          Criteria of the windows on which command should be executed.

          A value of `true` is equivalent to using an empty
          criteria (which is different from an empty string criteria).
        '';
      };
    };
  };
in
{
  options.modules.desktop.sway = {
    package = lib.mkOption {
      description = "Sway package";
      type = lib.types.package;
      default = pkgs.swayfx;
    };
    command = lib.mkOption {
      description = "Sway command";
      type = lib.types.str;
      default = "sway";
    };
    finalPackage = lib.mkOption {
      description = "Sway final package";
      type = lib.types.package;
      default = cfg.package.override {
        swayfx-unwrapped = pkgs.swayfx-unwrapped.overrideAttrs (old: {
          postInstall =
            let
              swaySession = ''
                [Desktop Entry]
                Name=Sway
                Comment=An i3-compatible Wayland compositor
                Exec=${cfg.command}
                Type=Application
              '';
            in
            ''
              [ ! -d $out/share/wayland-sessions ] && mkdir -p $out/share/wayland-sessions
              echo "${swaySession}" > $out/share/wayland-sessions/sway.desktop
            '';
          providedSessions = [ "sway" ];
        });
      };
    };
    shikane.enable = lib.mkEnableOption "Enable shikane";
    swaylock.enable = lib.mkEnableOption "Enable swaylock";
    floatingRules = mkOption {
      type = types.listOf windowCommandModule;
      default = [ ];
      description = ''
        List of commands that should be executed on specific windows.
      '';
    };
  };
}
