{
  pkgs,
  inputs,
  self,
  args,
  config,
  lib,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
  mkOpts =
    modules:
    inputs.unf.lib.json {
      inherit self pkgs modules;
      userOpts = {
        warningsAreErrors = false;
      };
      specialArgs = args // {
        inherit config lib;
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
    experimental.options_file = {
      # sops-nix = "${mkOpts [
      #   inputs.sops-nix.nixosModules.sops
      # ]}";
      nix-dots = "${mkOpts [ self.outputs.homeManagerModules.default ]}";
    };
  };
}
