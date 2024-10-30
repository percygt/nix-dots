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
    ./nixpkgs
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home = {
    inherit (g) username stateVersion homeDirectory;
    # activation = lib.optionalAttrs (!isGeneric) {
    #   rmUselessDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     rm -rf ${g.homeDirectory}/.nix-defexpr
    #     rm -rf ${g.homeDirectory}/.nix-profile
    #   '';
    # };
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
