{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    browser.brave.enable =
      lib.mkEnableOption "Enable brave";
  };

  config = lib.mkIf config.browser.brave.enable {
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
