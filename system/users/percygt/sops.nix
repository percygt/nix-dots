{
  hostName,
  inputs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
    validateSopsFiles = false;
    age.keyFile = "/etc/secrets/${hostName}.keyfile";
  };
}
