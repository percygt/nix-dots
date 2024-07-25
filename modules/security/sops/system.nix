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
  options.modules.security.sops.enable = lib.mkEnableOption "Enable sops";
  config = lib.mkIf config.modules.security.sops.enable {
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
      modules.security.ssh.enable = lib.mkDefault true;
    };
  };
}
