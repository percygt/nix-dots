{
  lib,
  username,
  stateVersion,
  homeDirectory,
  ...
}:
{
  imports = [
    ./xdg.hm.nix
    ./sessionVariables.hm.nix
    ./shellAliases.hm.nix

    ./nixpkgs.cmn.nix
    ./nix.cmn.nix
    ./fonts.cmn.nix

    ./nushell.hm.nix
    ./bash.hm.nix
    ./fish.hm.nix
    ./fish.hm.nix
    ./starship.hm.nix
    ./fzf.hm.nix
    ./eza.hm.nix
    ./zoxide.hm.nix
    ./misc.hm.nix
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
