{ inputs }:
{
  nix-sources = inputs.nix-sources.overlays.default;
  nix-stash = inputs.nix-stash.overlays.default;
  nixd = inputs.nixd.overlays.default;
  emacs = inputs.emacs-overlay.overlay;
  fenex = inputs.fenix.overlays.default;
  nur = inputs.nur.overlay;
  packageOverlays = final: _: import ../packages/overlays.nix { pkgs = final; };
  packageOverrides = _: prev: import ../packages/overrides.nix { inherit prev; };
}
