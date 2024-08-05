{ desktop, config, ... }:
let
  g = config._general;
in
{
  programs.dconf.enable = true;
  home-manager.users.${g.username} = {
    imports = [
      ./${desktop}.nix
      ./common.nix
    ];
  };
}
