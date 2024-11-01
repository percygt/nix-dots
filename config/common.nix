{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./terminal
    ]
    ++ lib.optionals (desktop != null) [
      ./apps
      ./desktop
    ];
}
