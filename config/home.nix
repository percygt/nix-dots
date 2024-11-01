{
  config,
  lib,
  homeMarker,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    ./shellAliases.nix
    ./sessionVariables.nix
    ./nixpkgs
    ./nix.nix
    ./xdg.nix
    ./qt.nix
    ./gtk.nix
    ./audio.nix
    ./automount.nix
  ] ++ lib.optional homeMarker ./common.nix;

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home = {
    inherit (g) username stateVersion homeDirectory;
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  news = {
    display = "silent";
    json = lib.mkForce { };
    entries = lib.mkForce [ ];
  };
}
