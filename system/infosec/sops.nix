{
  hostName,
  inputs,
  config,
  lib,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  options = {
    infosec.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.infosec.sops.enable {
    sops = {
      defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
      validateSopsFiles = false;
      # gnupg = {
      #   home = "${config.xdg.dataHome}/gnupg";
      #   sshKeyPaths = [];
      # };
      age.keyFile = "/etc/secrets/${hostName}-sops.keyfile";
    };
  };
}
