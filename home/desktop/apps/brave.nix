{
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  options = {
    desktop.apps.brave.enable =
      lib.mkEnableOption "Enable brave";
  };

  config = lib.mkIf config.desktop.apps.brave.enable {
    home.persistence."/persist/home/${username}" = {
      directories = [
        ".config/BraveSoftware/Brave-Browser"
      ];
    };
    programs.chromium = {
      package = pkgs.stash.brave;
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
