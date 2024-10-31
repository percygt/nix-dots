{
  config,
  buildMarker,
  lib,
  desktop,
  ...
}:
let
  g = config._general;
in
{
  imports =
    [
      ./shellAliases.nix
      ./sessionVariables.nix
      ./nixpkgs/overlay.nix
    ]
    ++ lib.optionals (buildMarker == "home") [
      ./nixpkgs/config.nix
      ./dev
      ./cli
      ./shell
      ./terminal
    ]
    ++ lib.optionals (buildMarker == "home" && desktop != null) [
      ./apps
      ./common
      ./desktop
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
