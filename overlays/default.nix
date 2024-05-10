{inputs, ...}: {
  packageOverlays = final: _:
    import ../packages/overlays.nix {pkgs = final;};
  packageOverrides = _: prev:
    import ../packages/overrides.nix {pkgs = prev;};
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
  nurpkgs = inputs.nurpkgs.overlay;
}
