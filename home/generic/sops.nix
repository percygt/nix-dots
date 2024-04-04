{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.security.sops.enable {
    systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
    home = {
      activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/systemctl start --user sops-nix
      '';
    };
  };
}
