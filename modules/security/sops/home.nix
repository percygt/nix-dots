{
  config,
  lib,
  inputs,
  pkgs,
  username,
  isGeneric,
  ...
}:
let
  secretsPath = builtins.toString inputs.sikreto;
  sopsStart =
    if isGeneric then
      "/usr/bin/systemctl --user start sops-nix"
    else
      "/run/current-system/sw/bin/systemctl --user start sops-nix";

  key =
    if isGeneric then
      {
        gnupg = {
          home = config.programs.gpg.homedir;
          sshKeyPaths = [ ];
        };
      }
    else
      { age.keyFile = "/persist/home/${username}/keys/home-sops.keyfile"; };
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  options.modules.security.sops.enable = lib.mkEnableOption "Enable sops";

  config = lib.mkIf config.modules.security.sops.enable {
    home.packages = [ pkgs.sops ];
    home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] sopsStart;
    sops = {
      defaultSopsFile = "${secretsPath}/secrets-home.enc.yaml";
      validateSopsFiles = false;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    } // key;
  };
}
