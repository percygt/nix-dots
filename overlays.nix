{inputs, ...}: {
  extra = final: prev:
    import ./packages {pkgs = final;};
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
}
