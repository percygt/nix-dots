{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: let
  systems = ["aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
in {
  forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
  mkSystem = {
    profile,
    useIso ? false,
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }: let
    inherit (inputs.nixpkgs) lib;
    mkArgs =
      import ./mkArgs.nix
      {inherit inputs outputs self username desktop stateVersion profile useIso;};
    homeArgs = mkArgs.args;
  in
    lib.nixosSystem {
      inherit system;
      modules =
        if useIso
        then ["${self}/installer/${profile}/configuration.nix"]
        else [outputs.nixosModules.default];
      specialArgs = {inherit homeArgs;} // mkArgs.args;
    };

  mkHome = {
    profile,
    isGeneric ? false,
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }
  : let
    inherit (inputs.home-manager) lib;
    mkArgs =
      import ./mkArgs.nix
      {inherit inputs outputs self username desktop stateVersion profile isGeneric;};
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [outputs.homeManagerModules.default];
      extraSpecialArgs = mkArgs.args;
    };
}
