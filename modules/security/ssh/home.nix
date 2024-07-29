{ lib, config, ... }:
{
  options.modules.security.ssh.enable = lib.mkEnableOption "Enable ssh";
  config = lib.mkIf config.modules.security.ssh.enable {
    programs.ssh = {
      enable = true;
      userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/additional_known_host";
      matchBlocks = {
        gitlab = {
          host = "gitlab.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/gpg-glab.pub" ];
        };
        github_autoup = lib.hm.dag.entryBefore [ "github" ] {
          host = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/id_ed25519_autoup" ];
        };
        github = {
          host = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/gpg-gh.pub" ];
        };
      };
    };
    home.file = {
      ".ssh/gpg-gh.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVxOzpUCJIUOtSPh46JY0Sz7H37pgzDAKWEcQzVcjY AF4";
      ".ssh/gpg-glab.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMySpo7UqnJPYVICF1gmVtgk5kLNbCvBuzYz8FMNl009 C14";
      ".ssh/additional_known_host".text = ''
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
      '';
    };
  };
}
