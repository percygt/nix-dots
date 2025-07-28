{ lib, config, ... }:
{
  config = lib.mkIf config.modules.app.chromium.enable {
    programs.chromium = {
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
