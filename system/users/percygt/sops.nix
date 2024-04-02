{
  self,
  hostName,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${self}/profiles/${hostName}/host.enc.yaml";
    validateSopsFiles = false;
    age.keyFile = "/etc/secrets/${hostName}.keyfile";
  };
}
