{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };
in
{
  home.packages = [ pkgs.nix-search-tv ];
  xdg.configFile."nix-search-tv/config.json" = {
    source = jsonFormat.generate "config.json" {
      indexes = [
        "nixpkgs"
        "home-manager"
        "nur"
        "nixos"
      ];
    };
  };
}
