{
  is_generic_linux,
  config,
  self,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = "${self}/lib/secrets/home-secrets.enc.yaml";
    gnupg = {
      home = "${config.xdg.dataHome}/gnupg";
      sshKeyPaths = [];
    };
    # age.keyFile = "/etc/home.keyfile";
    defaultSymlinkPath = "%r/secrets";
    defaultSecretsMountPoint = "%r/secrets.d";
  };
  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
  home = {
    activation.setupEtc =
      if is_generic_linux
      then
        (config.lib.dag.entryAfter ["writeBoundary"] ''
          /usr/bin/systemctl start --user sops-nix
        '')
      else
        (config.lib.dag.entryAfter ["writeBoundary"] ''
          /run/current-system/sw/bin/systemctl start --user sops-nix
        '');
  };
  home.packages = with pkgs; [
    sops
  ];
}
