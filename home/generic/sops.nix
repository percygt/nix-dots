{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.security.sops.enable {
    sops = {
      defaultSymlinkPath = "%r/secrets";
      defaultSecretsMountPoint = "%r/secrets.d";
    };
    systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
    home = {
      activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/systemctl start --user sops-nix
      '';
    };
    home.packages = with pkgs; [
      sops
    ];
  };
}
