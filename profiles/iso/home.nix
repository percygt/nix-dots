{
  listImports,
  config,
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
    "nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  xdg = {
    mime.enable = true;
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
  };

  services.ssh-agent.enable = true;
}
