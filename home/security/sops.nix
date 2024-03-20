{
  lib,
  is_generic_linux,
  config,
  self,
  ...
}:
lib.mkIf is_generic_linux
{
  sops = {
    defaultSopsFile = "${self}/lib/secrets/secrets.enc.yaml";
    gnupg = {
      home = "~/.gnupg";
      sshKeyPaths = [];
    };
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };
  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
  home = {
    activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/systemctl start --user sops-nix
    '';
  };
}
