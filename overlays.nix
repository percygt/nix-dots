{inputs, ...}: {
  extra = final: prev:
    import ./packages {pkgs = final;};
  nodePackages-extra = final: prev: {
    nodePackages-extra = import ./packages/node {
      pkgs = prev;
      inherit (prev) system;
      nodejs = prev.nodejs_20;
    };
  };
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
}
