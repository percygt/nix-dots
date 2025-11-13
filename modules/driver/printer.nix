{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.drivers.printer.enable {
    # hardware.printers.ensurePrinters = [ g.localPrinter ];
    # persistSystem.directories = [
    #   {
    #     directory = "/var/lib/cups";
    #     mode = "0755";
    #   }
    #   {
    #     directory = "/var/spool/cups";
    #     group = "lp";
    #     mode = "0710";
    #   }
    # ];
    environment.systemPackages = config.hardware.sane.extraBackends;
    programs.system-config-printer.enable = true;
    services = {
      udev.packages = config.hardware.sane.extraBackends;
      system-config-printer.enable = true;
      printing = {
        enable = true;
        drivers = with pkgs.old; [
          epson-201401w
          epson_201207w
          epson-201106w
        ];
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
          pkgs.simple-scan
        ];
      };
    };
    users.users.${username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
