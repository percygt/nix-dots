{flakeDirectory, ...}: {
  home = {
    shellAliases = {
      ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  cli = {
    direnv.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };
}
