{
  lib,
  config,
  ...
}: {
  options = {
    network.avahi = {
      enable =
        lib.mkEnableOption "Enable avahi";
    };
  };

  config = lib.mkIf config.network.avahi.enable {
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
