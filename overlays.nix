{inputs, ...}: {
  extra = final: prev:
    import ./packages {pkgs = final;};
  # nodePackages-extra = final: prev: {
  #   nodePackages-extra = import ./packages/prettier-plugin-astro.nix {pkgs = final;};
  # };
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
}
