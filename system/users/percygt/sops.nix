{
  hostName,
  inputs,
  ...
}: let
  sikreto = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${sikreto}/secrets.enc.yaml";
    validateSopsFiles = false;
    age.keyFile = "/etc/secrets/${hostName}.keyfile";
  };
}
