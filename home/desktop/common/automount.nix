{
  config,
  pkgs,
  ...
}: {
  sops.secrets."backup/key" = {};
  services.udiskie = {
    enable = true;
    tray = "auto";
    notify = true;
    automount = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
      };
      device_config = [
        {
          id_uuid = "129829fa-acfb-4c09-815d-b450ebaa9262";
          keyfile = config.sops.secrets."backup/key".path;
        }
        {
          id_uuid = "cbba3a5a-81e5-4146-8895-641602b712a5";
          automount = false;
        }
      ];
    };
  };
  systemd.user.services.udiskie.Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 15";
}
