{ inputs }:
{
  nix-sources = inputs.nix-sources.overlays.default;
  nix-stash = inputs.nix-stash.overlays.default;
  nixd = inputs.nixd.overlays.default;
  fenix = inputs.fenix.overlays.default;
  nur = inputs.nur.overlays.default;
  niri = inputs.niri.overlays.niri;
  nixpkgs-variants = final: _: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system config;
    };
    master = import inputs.nixpkgs-master {
      inherit (final) system config;
    };
    old = import inputs.nixpkgs-old {
      inherit (final) system config;
    };
  };
  packageOverrides = _: prev: import ../packages/overrides.nix { inherit prev inputs; };
  packageOverlays =
    final: _:
    import ../packages/overlays.nix {
      pkgs = final;
    };
}
