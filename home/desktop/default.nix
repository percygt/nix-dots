{
  desktop,
  lib,
  ...
}: {
  imports =
    [./modules]
    ++ lib.optionals (desktop != null) [
      ./${desktop}
    ];
}
