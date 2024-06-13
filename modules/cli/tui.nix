{pkgs, ...}: {
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
}
