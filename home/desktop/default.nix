{
  desktop,
  lib,
  ...
}: {
  imports =
    [
      ./common
      ./apps
    ]
    ++ lib.optionals (desktop != null) [
      ./${desktop}
    ];
}
