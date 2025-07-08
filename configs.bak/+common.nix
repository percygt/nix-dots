{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./rebuild
      ./utils
    ]
    ++ lib.optionals (desktop != null) [
      ./app
      ./terminal
      ./desktop
      ./ui
    ];
}
