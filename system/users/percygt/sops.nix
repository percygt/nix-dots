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
    age.keyFile = "/etc/secrets/${hostName}.keyfile";
    secrets = {
      user-hashedPassword.neededForUsers = true;
    };
  };
}
