{ buildMarker, lib, ... }:
{
  imports =
    [
      ./xdg
      ./qt.nix
      ./gtk.nix
      ./audio.nix
      ./automount.nix
    ]
    ++ lib.optionals (buildMarker == "home") [
      ./dconf
    ];
}
