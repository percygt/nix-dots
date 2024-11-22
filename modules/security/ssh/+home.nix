{
  lib,
  config,
  ...
}:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.security.ssh.enable {
    programs.ssh = {
      enable = true;
      inherit (g.security.ssh) package;
      userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/additional_known_host";
      matchBlocks = {
        gitlab = {
          host = "gitlab.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/gpg-glab.pub" ];
        };
        github = {
          host = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/gpg-gh.pub" ];
        };
      };
    };
    home.file = {
      ".ssh/gpg-gh.pub".text = g.security.ssh.ghPublicKey;
      ".ssh/gpg-glab.pub".text = g.security.ssh.glabPublicKey;
      ".ssh/additional_known_host".text = ''
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
      '';
    };
  };
}
