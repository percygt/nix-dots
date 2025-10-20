{ config, ... }:
{
  programs.dconf.profiles.user.databases = [
    { settings = import ./__dconf.nix { inherit config; }; }
  ];
}
