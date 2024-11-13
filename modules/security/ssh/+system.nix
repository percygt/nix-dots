{
  lib,
  config,
  ...
}:
let
  g = config._base;
in
{
  # imports = [ ./module.nix ];
  config = lib.mkIf config.modules.security.ssh.enable {
    modules.core.persist.systemData.directories = [ "/etc/ssh" ];
    modules.core.persist.userData.directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
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
