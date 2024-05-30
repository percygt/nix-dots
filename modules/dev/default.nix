{
  lib,
  username,
  ...
}: {
  home-manager.users.${username}.imports = [
    ./git
    ./go.nix
    ./common.nix
    {
      dev = {
        git.enable = lib.mkDefault true;
      };
    }
  ];
}
