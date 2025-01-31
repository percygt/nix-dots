{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.driver.printer.enable {
    # hardware.printers.ensurePrinters = [ g.localPrinter ];
    environment.systemPackages = config.hardware.sane.extraBackends;
    programs.system-config-printer.enable = true;
    services = {
      udev.packages = config.hardware.sane.extraBackends;
      system-config-printer.enable = true;
      printing = {
        enable = true;
        drivers = [ pkgs.stable.epson-201401w ];
      };
    };
    hardware = {
      sane = {
        enable = true;
        extraBackends = [
          (pkgs.epsonscan2.override {
            withNonFreePlugins = true;
          })
          pkgs.utsushi
        ];
      };
    };
    users.users.${username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
