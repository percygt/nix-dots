{
  lib,
  username,
  ...
}: {
  imports = lib.optionals (builtins.pathExists ./${username}) [
    ./${username}
  ];
}
