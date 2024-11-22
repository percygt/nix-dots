{
  libx,
  isGeneric,
  isIso,
  isDroid,
  ...
}:
if isIso then
  { imports = [ ./iso ]; }
else if isDroid then
  { imports = [ ./droid ]; }
else if isGeneric then
  { imports = [ ./generic ]; }
else
  libx.importPaths.default ./.
