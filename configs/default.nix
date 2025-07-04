{
  isGeneric,
  isIso,
  isDroid,
  username,
  ...
}:
if isIso then
  { imports = [ ./iso ]; }
else if isDroid then
  { imports = [ ./droid ]; }
else if isGeneric then
  { imports = [ ./generic ]; }
else
  {
    imports = [
      ./+system
      ./+system.nix
      ./+common.nix
    ];
    home-manager.users.${username} = {
      imports = [
        ./+home
        ./+home.nix
        ./+common.nix
      ];
    };
  }
