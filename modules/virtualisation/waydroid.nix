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
    environment.systemPackages = with pkgs; [
      nur.repos.ataraxiasjel.waydroid-script
      waydroid-helper
      android-tools
    ];
    systemd = {
      packages = [ pkgs.waydroid-helper ];
      services.waydroid-mount.wantedBy = [ "multi-user.target" ];
    };
    services.geoclue2.enable = true;
    persistSystem.directories = [
      "/var/lib/waydroid"
      # "/etc/waydroid-extra/images"
    ];
    persistHome.directories = [
      ".local/share/waydroid-helper"
      ".local/cache/waydroid-helper"
      ".config/waydroid-helper"
      ".local/share/waydroid"
      ".cache/waydroid-script"
    ];
  };
}
