{ profile, ... }:
{
  imports = [
    ./common
    ./${profile}
  ];
}
