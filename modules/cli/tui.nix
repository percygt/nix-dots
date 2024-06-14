{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    cli.tui.enable =
      lib.mkEnableOption "Enable tui";
  };

  config = lib.mkIf config.cli.tui.home.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          theme_background = "False";
          vim_keys = "True";
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
