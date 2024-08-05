{
  inputs,
  config,
  lib,
  libx,
  ...
}:
let
  g = config._general;
  secretsPath = builtins.toString inputs.sikreto;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  options.modules.security.sops.enable = libx.enableDefault "sops";
  config = lib.mkIf config.modules.security.sops.enable {
    home-manager.users.${g.username} = import ./home.nix;
    sops = {
      defaultSopsFile = "${secretsPath}/secrets-system.enc.yaml";
      validateSopsFiles = false;
      age = {
        keyFile = "/persist/system/keys/system-sops.keyfile";
        sshKeyPaths = [ ];
      };
      gnupg.sshKeyPaths = [ ];
    };
  };
}
