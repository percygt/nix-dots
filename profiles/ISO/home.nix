{
  listImports,
  config,
  username,
  ...
}: let
  modules = [
    "shell/fish.nix"
    "fonts.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
    "nix.nix"
    "cli.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  xdg = {
    mime.enable = true;
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
  };

  programs.ssh = {
    extraConfig = ''
      Host gitlab.com
        PreferredAuthentications publickey
        IdentityFile /run/media/${username}/v/.k/.ssh/id_ed25519_glab
    '';
    hashKnownHosts = true;
    enable = true;
  };
  services.ssh-agent.enable = true;
}
