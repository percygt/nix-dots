{
  inputs,
  lib,
  config,
  ...
}: {
  options.core.autoupgrade = {
    enable = lib.mkOption {
      description = "Enable autoupgrade";
      default = false;
      type = lib.types.bool;
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
