{
  desktop,
  lib,
  ...
}: {
  imports =
    [
      ./modules
      ./programs
    ]
    ++ lib.optionals (desktop != null) [
      ./${desktop}
    ];
}
