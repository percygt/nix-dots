{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/additional_known_host";
    extraConfig = ''
      Host gitlab.com
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/gpg-glab.pub

      Host github.com
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/gpg-gh.pub
    '';
  };
  services.ssh-agent.enable = false;
  home.file.".ssh/additional_known_host".text = ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
  '';
}
