{
  username,
  isGeneric,
  homeMarker,
  ...
}:
if (!isGeneric && !homeMarker) then
  {
    imports = [
      ./_sys.nix
    ];
    home-manager.users.${username} = {
      imports = [
        ./_hm.nix
      ];
    };
  }
else
  {
    imports = [
      ./_hm.nix
    ];
  }
