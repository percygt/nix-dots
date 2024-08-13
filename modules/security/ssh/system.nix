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
    nix.sshServe.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVxOzpUCJIUOtSPh46JY0Sz7H37pgzDAKWEcQzVcjY AF4"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMySpo7UqnJPYVICF1gmVtgk5kLNbCvBuzYz8FMNl009 C14"
    ];

    # not needed, i use gpg-agent
    programs.ssh.startAgent = lib.mkForce false;

    networking.firewall.allowedTCPPorts = [ 22 ];

  };
}
