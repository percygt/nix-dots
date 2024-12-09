{ inputs }:
{
  nix-sources = inputs.nix-sources.overlays.default;
  nix-stash = inputs.nix-stash.overlays.default;
  nixd = inputs.nixd.overlays.default;
  emacs = inputs.emacs-overlay.overlays.default;
  nur = inputs.nur.overlays.default;
  packageOverrides = _: prev: import ../packages/overrides.nix { inherit prev; };
  packageOverlays =
    final: _:
    import ../packages/overlays.nix {
      pkgs = final;
    };
}
