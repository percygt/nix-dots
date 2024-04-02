{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.security.sops.enable {
    sops = {
      gnupg = {
        home = "~/.gnupg";
        sshKeyPaths = [];
      };
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
