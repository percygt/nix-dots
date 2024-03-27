{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${self}/lib/secrets/server-secrets.enc.yaml";
    gnupg = {
      home = "~/.gnupg";
      sshKeyPaths = [];
    };
    age.sshKeyPaths = ["/etc/nixos/system.keyfile"];
  };
}
