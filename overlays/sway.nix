{inputs, ...}: {
  nixpkgs-wayland = inputs.nixpkgs-wayland.overlay;
  swayfx-unwrapped = inputs.swayfx-unwrapped.overlays.default;
}
