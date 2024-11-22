{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./rebuild
      ./utility
    ]
    ++ lib.optionals (desktop != null) [
      ./app
      ./terminal
      ./desktop
      ./ui
    ];
}
