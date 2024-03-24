{self, ...}: {
  sops = {
    defaultSopsFile = "${self}/lib/secrets/system.enc.yaml";
    age.keyFile = "/etc/nixos/system.keyfile";
  };
}
