{
  config,
  isGeneric,
  lib,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    ./shellAliases.nix
    ./sessionVariables.nix
    ./nixpkgs/overlay.nix
  ];

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
