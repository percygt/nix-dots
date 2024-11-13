{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./terminal
      ./rebuild
      ./utility
    ]
    ++ lib.optionals (desktop != null) [
      ./app
      ./desktop
      ./ui
    ];
}
