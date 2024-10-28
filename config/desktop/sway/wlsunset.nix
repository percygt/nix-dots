{ pkgs, ... }:
{
  home.packages = [ pkgs.wlsunset ];
  services.wlsunset = {
    enable = true;
    systemdTarget = "null.target";
    latitude = "14.5";
    longitude = "120.9";
    temperature = {
      day = 7000;
      night = 3000;
    };
  };
}
