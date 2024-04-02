{
  config,
  self,
  pkgs,
  lib,
  ...
}: {
  options = {
    generic.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.generic.sops.enable {
    sops = {
      defaultSopsFile = "${self}/home/users/percygt/user.enc.yaml";
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
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
