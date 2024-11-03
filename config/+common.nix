{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./terminal
      ./rebuild
      ./utils
    ]
    ++ lib.optionals (desktop != null) [
      ./apps
      ./desktop
      ./ui
    ];
}
