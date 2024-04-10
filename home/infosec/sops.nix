{
  config,
  lib,
  inputs,
  pkgs,
  username,
  isGeneric,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
  sopsStart =
    if isGeneric
    then "/usr/bin/systemctl start --user sops-nix"
    else "/run/current-system/sw/bin/systemctl start --user sops-nix";
  key =
    if isGeneric
    then {
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    }
    else {
      age.keyFile = "/home/${username}/.nixos/keys/home-sops.keyfile";
    };
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
    home.packages = [pkgs.sops];
    home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] sopsStart;
    sops =
      {
        defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
        validateSopsFiles = false;
        defaultSymlinkPath = "/run/user/1000/secrets";
        defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      }
      // key;
  };
}
