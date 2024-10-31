{ lib, buildMarker, ... }:
{
  imports =
    [
      ./loupe.nix
      ./mpv.nix
      ./quickemu.nix
      ./zathura.nix
    ]
    ++ lib.optionals (buildMarker == "home") [
      ./chromium
      ./common
    ];
}
