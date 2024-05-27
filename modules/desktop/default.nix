{
  desktop,
  lib,
  ...
}: {
  imports = lib.optionals (desktop != null) [
    ./${desktop}
    ./common
    ./apps
  ];
}
