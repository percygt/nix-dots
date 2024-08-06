{
  inputs,
  config,
  lib,
  libx,
  ...
}:
let
  g = config._general;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  options.modules.security.sops.enable = libx.enableDefault "sops";
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
