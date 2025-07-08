{
  lib,
  username,
  stateVersion,
  homeDirectory,
  ...
}:
{
  imports = [
    ./nixpkgs
    ./nix.nix
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home = {
    inherit username stateVersion homeDirectory;
  };

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
