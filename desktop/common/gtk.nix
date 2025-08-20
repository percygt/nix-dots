{ config, ... }:
{
  programs.dconf.profiles.user.databases = [
    { settings = import ./.dconf.nix { inherit config; }; }
  ];
}
