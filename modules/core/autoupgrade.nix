{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    core.autoupgrade = {
      enable =
        lib.mkEnableOption "Enable autoupgrade";
    };
  };

  config = lib.mkIf config.core.autoupgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
