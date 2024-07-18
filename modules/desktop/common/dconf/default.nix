{ desktop, username, ... }:
{
  programs.dconf.enable = true;
  home-manager.users.${username} = {
    imports = [
      ./${desktop}.nix
      ./common.nix
    ];
  };
}
