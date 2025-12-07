{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.virtualisation.waydroid.enable {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
    services.geoclue2.enable = true;
    programs.adb.enable = true;
    persistSystem.directories = [ "/var/lib/waydroid" ];
    persistHome.directories = [ ".local/share/waydroid" ];
  };
}
