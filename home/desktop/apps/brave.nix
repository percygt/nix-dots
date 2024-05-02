{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    desktop.apps.brave.enable =
      lib.mkEnableOption "Enable brave";
  };

  config = lib.mkIf config.desktop.apps.brave.enable {
    programs.chromium = {
      package = pkgs.brave;
      enable = true;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      ];
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };
  };
}
