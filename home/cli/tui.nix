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

  config = lib.mkIf config.cli.tui.enable {
    programs = {
      bottom.enable = true;
      lazygit.enable = true;
    };
    home.packages = with pkgs; [
      # tui
      termscp # file transfer and explorer, with support for SCP/SFTP/FTP/S3
      visidata # interactive multitool for tabular data
      wtf # personal information dashboard
      lazydocker
      lazysql
      podman-tui
      jqp
      youtube-tui
      gpg-tui
    ];
  };
}
