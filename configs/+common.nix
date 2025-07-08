{ lib, desktop, ... }:
{
  imports =
    [
      ./cli
      ./shell
      ./rebuild
      ./utils
    ]
    ++ lib.optionals (desktop != null) [
      ./app
      ./desktop
      ./ui
    ];
}
