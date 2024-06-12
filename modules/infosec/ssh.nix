{
  lib,
  config,
  username,
  ...
}: {
  options.infosec = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh";
    };
  };
  config = lib.mkIf config.infosec.ssh.enable {
    home-manager.users.${username} = {config, ...}: {
      programs.ssh = {
        enable = true;
        userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/additional_known_host";
        matchBlocks = {
          gitlab = {
            host = "gitlab.com";
            identitiesOnly = true;
            identityFile = ["~/.ssh/gpg-glab.pub"];
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
          };
          github = {
            host = "github.com";
            identitiesOnly = true;
            identityFile = ["~/.ssh/gpg-gh.pub"];
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
          };
        };
      };
      services.ssh-agent.enable = lib.mkForce false;
      home.file = {
        ".ssh/gpg-gh.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVxOzpUCJIUOtSPh46JY0Sz7H37pgzDAKWEcQzVcjY AF4";
        ".ssh/gpg-glab.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMySpo7UqnJPYVICF1gmVtgk5kLNbCvBuzYz8FMNl009 C14";
        ".ssh/additional_known_host".text = ''
          github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        '';
      };
    };
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

    networking.firewall.allowedTCPPorts = [22];

    environment.persistence = {
      "/persist/system".directories = [
        "/etc/ssh"
      ];
      "/persist".users.${username}.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
