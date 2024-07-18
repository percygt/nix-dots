{
  inputs,
  config,
  lib,
  username,
  ...
}:
let
  secretsPath = builtins.toString inputs.sikreto;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  options.infosec.sops.system.enable = lib.mkEnableOption "Enable sops";
  config = lib.mkIf config.infosec.sops.system.enable {
    sops = {
      defaultSopsFile = "${secretsPath}/secrets-system.enc.yaml";
      validateSopsFiles = false;
      age = {
        keyFile = "/persist/system/keys/system-sops.keyfile";
        sshKeyPaths = [ ];
      };
      gnupg.sshKeyPaths = [ ];
    };

    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      infosec.ssh.home.enable = lib.mkDefault true;
    };
  };
}
