{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    extra.autoupgrade = {
      enable =
        lib.mkEnableOption "Enable autoupgrade";
    };
  };

  config = lib.mkIf config.extra.autoupgrade.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
