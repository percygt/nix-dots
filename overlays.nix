{inputs, ...}: {
  extra = final: _:
    import ./packages {pkgs = final;};
  nix-stash = inputs.nix-stash.overlays.default;
  neovim-nightly = inputs.neovim-nightly-overlay.overlay;
  nodePackages-extra = final: _: {
    nodePackages-extra = import ./packages/node rec {
      pkgs = final;
      inherit (pkgs) system;
      nodejs = pkgs.nodejs_20;
    };
  };
}
