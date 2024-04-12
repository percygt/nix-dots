{
  lib,
  config,
  ...
}: {
  options.infosec = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh";
    };
  };
  config = lib.mkIf config.infosec.ssh.enable {
    services.openssh = {
      enable = lib.mkDefault false;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    nix.sshServe.enable = lib.mkDefault false;
    nix.sshServe.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVxOzpUCJIUOtSPh46JY0Sz7H37pgzDAKWEcQzVcjY AF4"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMySpo7UqnJPYVICF1gmVtgk5kLNbCvBuzYz8FMNl009 C14"
    ];

    programs.ssh.startAgent = lib.mkForce false;

    networking.firewall.allowedTCPPorts = [22];
  };
}
