{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._global;
in
{
  config = lib.mkIf config.modules.app.brave.enable {
    # disable NativeMessagingHosts symlink
    home.file."${g.xdg.configHome}/BraveSoftware/Brave-Browser/NativeMessagingHosts".enable = false;
    programs.brave = {
      enable = true;
      package = pkgs.unstable.brave;
      commandLineArgs = [ "--password-store=basic" ];
      extensions =
        let
          ids = [
            "ficfmibkjjnpogdcfhfokmihanoldbfe" # File Icons for GitHub and GitLab
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
            "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
          ];
        in
        map (id: { inherit id; }) ids;
    };
  };
}
