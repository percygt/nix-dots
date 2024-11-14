{
  username,
  stateVersion,
  homeDirectory,
  ...
}:
{
  imports = [ ../nixpkgs/overlay.nix ];
  programs.home-manager.enable = true;

  home = {
    inherit username stateVersion homeDirectory;
    shellAliases.ni = "sudo nixos-install --no-root-passwd --flake";
  };
}
