{
  config,
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
      ./nixpkgs
      ./nix.nix
      ./xdg.nix
      ./audio.nix
      ./automount.nix
    ]
    ++ lib.optionals (desktop != null) [
      ./fonts.nix
      ./themes.nix
      ./qt.nix
      ./gtk.nix
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
