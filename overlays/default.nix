{ inputs, ... }:
{
  nix-sources = inputs.nix-sources.overlays.default;
  nix-stash = inputs.nix-stash.overlays.default;
  # neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;
  nixd = inputs.nixd.overlays.default;
  # emacs = inputs.emacs-overlay.overlay;
  fenex = inputs.fenix.overlays.default;
  packageOverlays = final: _: import ../packages/overlays.nix { pkgs = final; };
  packageOverrides = final: prev: import ../packages/overrides.nix { inherit prev inputs; };
}
