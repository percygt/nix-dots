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
      # bottom = {
      #   enable = true;
      #   settings = {
      #     flags = {
      #       avg_cpu = true;
      #       temperature_type = "c";
      #       enable_gpu = true;
      #     };
      #
      #     colors = {
      #       low_battery_color = "red";
      #     };
      #   };
      # };
      btop = {
        enable = true;
        package = pkgs.btop.override {
          cudaSupport = true;
        };
        # package = pkgs.btop.overrideAttrs (oldAttrs: {
        #   nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.addOpenGLRunpath];
        #   postFixup = ''
        #     addOpenGLRunpath $out/bin/btop
        #   '';
        # });
        settings = {
          theme_background = "True";
          vim_keys = "True";
        };
      };
      lazygit.enable = true;
    };
    home.packages = with pkgs; [
      # tui
      # nvtopPackages.full
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
