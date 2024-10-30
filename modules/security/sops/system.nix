{
  inputs,
  config,
  lib,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./module.nix
  ];
  config = lib.mkIf config.modules.security.sops.enable {
    home-manager.users.${g.username} = import ./home.nix;
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
