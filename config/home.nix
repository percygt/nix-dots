{
  username,
  stateVersion,
  homeDirectory,
  isGeneric,
  lib,
  ...
}:
{
  imports = [
    ./shellAliases.nix
    ./sessionVariables.nix
    ./nixpkgs/overlay.nix
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home = {
    inherit username stateVersion homeDirectory;
    activation = lib.optionalAttrs (!isGeneric) {
      rmUselessDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf ${homeDirectory}/.nix-defexpr
        rm -rf ${homeDirectory}/.nix-profile
      '';
    };
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
