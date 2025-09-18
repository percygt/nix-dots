{
  pkgs,
  inputs,
  self,
  config,
  homeDirectory,
  username,
  profile,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
  mkOpts =
    module:
    inputs.unf.lib.json {
      inherit self pkgs;
      modules = [ module ];
      userOpts = {
        warningsAreErrors = false;
      };
      specialArgs = {
        inherit
          inputs
          config
          homeDirectory
          username
          profile
          ;
      };
    };
in
{
  home.packages = [ pkgs.nix-search-tv ];
  xdg.configFile."nix-search-tv/config.json".source = jsonFormat.generate "config.json" {
    indexes = [
      "nixpkgs"
      "home-manager"
      "nur"
      "nixos"
    ];
    experimental = {
      options_file = {
        sops-nix = "${mkOpts inputs.sops-nix.nixosModules.sops}";
        flake = "${mkOpts self.outputs.homeManagerModules.default}";
      };
    };
  };
}
