{ inputs }:
{
  nix-sources = inputs.nix-sources.overlays.default;
  nix-stash = inputs.nix-stash.overlays.default;
  nixd = inputs.nixd.overlays.default;
  fenix = inputs.fenix.overlays.default;
  nur = inputs.nur.overlays.default;
  nixpkgs-variants = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
    stable = import inputs.nixpkgs-stable {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
    master = import inputs.nixpkgs-master {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
    old = import inputs.nixpkgs-old {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
  };
  packageOverrides = final: prev: import ../packages/overrides.nix { inherit final prev; };
  packageOverlays =
    final: _:
    import ../packages/overlays.nix {
      pkgs = final;
    };
}
