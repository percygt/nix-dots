{
  lib,
  config,
  ...
}: {
  options = {
    net.avahi = {
      enable =
        lib.mkEnableOption "Enable avahi";
    };
  };

  config = lib.mkIf config.net.avahi.enable {
    # network discovery, mDNS
    services.avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
