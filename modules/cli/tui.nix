{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cli.tui.home.enable = lib.mkEnableOption "Enable tui's";
  config = lib.mkIf config.cli.tui.home.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
        };
      };
      lazygit.enable = true;
    };
    home.packages = with pkgs; [
      # tui
      nvtopPackages.full
      termscp # file transfer and explorer, with support for SCP/SFTP/FTP/S3
      visidata # interactive multitool for tabular data
      wtf # personal information dashboard
      bluetuith
      lazydocker
      lazysql
      podman-tui
      jqp
      ytui-music
      gpg-tui
    ];
  };
}
