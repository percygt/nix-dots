{
  libx,
  isGeneric,
  isIso,
  ...
}:
if isIso then
  { imports = [ ./iso ]; }
else if isGeneric then
  { imports = [ ./generic ]; }
else
  libx.importPaths.default ./.
