{
  inputs,
  config,
  username,
  isGeneric,
  pkgs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
  sopsStart =
    if isGeneric
    then "/usr/bin/systemctl --user start sops-nix"
    else "/run/current-system/sw/bin/systemctl --user start sops-nix";

  key =
    if isGeneric
    then {
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    }
    else {
      age.keyFile = "/persist/home/${username}/keys/home-sops.keyfile";
    };
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  home.packages = [pkgs.sops];
  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] sopsStart;
  sops =
    {
      defaultSopsFile = "${secretsPath}/secrets-home.enc.yaml";
      validateSopsFiles = false;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    }
    // key;
}
