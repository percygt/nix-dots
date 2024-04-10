{
  flakeDirectory,
  self,
  ...
}: {
  home = {
    shellAliases = {
      ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  home.file.nix-dots = {
    recursive = true;
    source = self;
  };
  editor.neovim.enable = true;

  cli = {
    direnv.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };
}
