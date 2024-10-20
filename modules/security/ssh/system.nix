{
  lib,
  config,
  libx,
  ...
}:
let
  g = config._general;
in
{
  options.modules.security.ssh.enable = libx.enableDefault "ssh";
  config = lib.mkIf config.modules.security.ssh.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [ "/etc/ssh" ];
      "/persist".users.${g.username}.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
    home-manager.users.${g.username} = import ./home.nix;
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
