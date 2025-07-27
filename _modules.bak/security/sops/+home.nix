{
  config,
  lib,
  inputs,
  pkgs,
  isGeneric,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    # ./module.nix
  ];

  config = lib.mkIf config.modules.security.sops.enable {
    home.packages = [ pkgs.sops ];
    sops = {
      defaultSopsFile = g.homeSopsFile;
      validateSopsFiles = false;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      gnupg = lib.mkIf isGeneric {
        home = config.programs.gpg.homedir;
        sshKeyPaths = [ ];
      };
      age = lib.mkIf (!isGeneric) { keyFile = g.homeKeyfile; };
    };
  };
}
