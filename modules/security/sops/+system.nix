{
  inputs,
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    # ./module.nix
  ];
  config = lib.mkIf config.modules.security.sops.enable {
    sops = {
      defaultSopsFile = g.systemSopsFile;
      validateSopsFiles = false;
      age = {
        keyFile = g.systemKeyfile;
        sshKeyPaths = [ ];
      };
      gnupg.sshKeyPaths = [ ];
    };
  };
}
