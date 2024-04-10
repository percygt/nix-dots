{
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
      age = {
        keyFile = "/etc/nixos/keys/system-sops.keyfile";
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        generateKey = true;
      };
      gnupg.sshKeyPaths = [];
    };
  };
}
