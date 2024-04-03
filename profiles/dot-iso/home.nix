{
  pkgs,
  config,
  ...
}: {
  userModules = {
    git = {
      enable = true;
      gh.enable = true;
      glab.enable = true;
      credentials.enable = true;
    };
    gpg.enable = true;
    ssh.enable = true;
  };

  security = {
    sops.enable = true;
  };

  cli = {
    direnv.enable = true;
    fzf.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };

  sops = {
    defaultSymlinkPath = "%r/secrets";
    defaultSecretsMountPoint = "%r/secrets.d";
  };
  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
  home = {
    activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
      /run/current-system/sw/bin/systemctl start --user sops-nix
    '';
  };
}
