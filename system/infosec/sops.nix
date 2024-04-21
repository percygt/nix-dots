{
  inputs,
  config,
  lib,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in {
  options = {
    infosec.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.infosec.sops.enable {
    sops = {
      defaultSopsFile = "${secretsPath}/secrets-system.enc.yaml";
      validateSopsFiles = false;
      age = {
        keyFile = "/persist/system/keys/system-sops.keyfile";
        sshKeyPaths = [];
      };
      gnupg.sshKeyPaths = [];
    };
  };
}
