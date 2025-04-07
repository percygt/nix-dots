{ lib, ... }:
with lib;
let
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
    kanshi.enable = lib.mkEnableOption "Enable kanshi";
    floatingRules = mkOption {
      type = types.listOf windowCommandModule;
      default = [ ];
      description = ''
        List of commands that should be executed on specific windows.
      '';
    };
  };
}
