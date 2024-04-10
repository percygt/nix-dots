{
  config,
  lib,
  inputs,
  pkgs,
  isGeneric,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
  sops_start =
    if isGeneric
    then "/usr/bin/systemctl start --user sops-nix"
    else "/run/current-system/sw/bin/systemctl start --user sops-nix";
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
      defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
      validateSopsFiles = false;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    };
    home = {
      activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] sops_start;
    };
  };
}
