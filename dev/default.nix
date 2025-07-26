{
  username,
  isGeneric,
  homeMarker,
  libx,
  ...
}:
if (!isGeneric && !homeMarker) then
  {
    imports = libx.import_nixosmodules ./.;
    home-manager.users.${username} = {
      imports = libx.import_hmmodules ./.;
    };
  }
else
  {
    imports = libx.import_hmmodules ./.;
  }
