{
  lib,
  config,
  username,
  ...
}:
let
  g = config._general;
in
{
  # imports = [ ./module.nix ];
  config = lib.mkIf config.modules.security.ssh.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [ "/etc/ssh" ];
      "/persist".users.${username}.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
    services.openssh = {
      enable = lib.mkDefault false;
      inherit (g.security.ssh) package;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    nix.sshServe.enable = lib.mkDefault false;
    # not needed, i use gpg-agent
    programs.ssh.startAgent = lib.mkForce false;

    networking.firewall.allowedTCPPorts = [ 22 ];

  };
}
