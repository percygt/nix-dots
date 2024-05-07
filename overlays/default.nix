{inputs, ...}: {
  extra = final: _:
    import ../packages/overlays.nix {pkgs = final;};
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
  nurpkgs = inputs.nurpkgs.overlay;
  unfree = _final: prev: {
    unfree = inputs.nixpkgs-unfree.legacyPackages.${prev.system};
  };
}
