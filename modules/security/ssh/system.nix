{
  lib,
  config,
  username,
  ...
}:
{
  options.modules.security.ssh.enable = lib.mkEnableOption "Enable ssh";
  config = lib.mkIf config.modules.security.ssh.enable {
    services.openssh = {
      enable = lib.mkDefault false;
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

    environment.persistence = {
      "/persist/system".directories = [ "/etc/ssh" ];
      "/persist".users.${username}.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.security.sops.enable = lib.mkDefault true;
    };
  };
}
