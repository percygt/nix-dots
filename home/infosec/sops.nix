{
  config,
  lib,
  inputs,
  useGenericLinux,
  pkgs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    infosec.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.infosec.sops.enable {
    home.packages = with pkgs; [
      sops
    ];
    sops = {
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
      validateSopsFiles = false;
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    };
    systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
    home = {
      activation.setupEtc =
        if useGenericLinux
        then
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /usr/bin/systemctl start --user sops-nix
          '')
        else
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /run/current-system/sw/bin/systemctl start --user sops-nix
          '');
    };
  };
}
