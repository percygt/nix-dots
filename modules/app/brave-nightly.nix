{ lib, config, ... }:
{
  config = lib.mkIf config.modules.app.chromium.webapps.zoom.enable {

    programs.brave-nightly = {
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
