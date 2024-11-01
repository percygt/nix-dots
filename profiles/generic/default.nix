{
  config,
  self,
  pkgs,
  ...
}:
let
  g = config._general;
  c = "${self}/config";
in
{
  imports = [
    ./xremap.nix
    ./bluez-suspend.nix
    ./nvd.nix
    "${c}/home.nix"
    "${c}/apps"
    "${c}/cli"
    "${c}/dev"
    "${c}/shell"
    "${c}/desktop"
    "${c}/nixpkgs/config.nix"
    "${c}/nix.nix"
    "${c}/xdg.nix"
    "${c}/qt.nix"
    "${c}/gtk.nix"
    "${c}/audio.nix"
    "${c}/automount.nix"
  ];
  home.packages = g.system.corePackages;
  nix.package = pkgs.nixVersions.latest;
}
