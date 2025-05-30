{ lib, config, ... }:
{
  config = lib.mkIf config.modules.app.chromium-webapps.zoom.enable {
    # disable NativeMessagingHosts symlink
    home.file."${config.xdg.configHome}/BraveSoftware/Brave-Browser/NativeMessagingHosts".enable =
      false;
    programs.brave = {
      enable = true;
      commandLineArgs = [
        "--password-store=basic"
      ];
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    };
  };
}
