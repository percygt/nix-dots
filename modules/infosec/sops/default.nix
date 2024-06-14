{
  inputs,
  config,
  lib,
  isGeneric,
  username,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in
  {
    options = {
      infosec.sops = {
        enable =
          lib.mkEnableOption "Enable sops";
      };
    };
  }
  // {
    config = lib.mkIf config.infosec.sops.enable (
      if isGeneric
      then {imports = [./home.nix];}
      else {
        home-manager.users.${username} = import ./home.nix;
        sops = {
          defaultSopsFile = "${secretsPath}/secrets-system.enc.yaml";
          validateSopsFiles = false;
          age = {
            keyFile = "/persist/system/keys/system-sops.keyfile";
            sshKeyPaths = [];
          };
          gnupg.sshKeyPaths = [];
        };
      }
    );
  }
