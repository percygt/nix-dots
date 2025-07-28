# source: https://github.com/stelcodes/nixos-config/commit/3367a480af74f2ff4442f01da6e320424820da8d
{
  writeTextFile,
  babashka-unwrapped,
  lib,
  runtimeShell,
}:
{
  name,
  text,
  runtimeInputs ? [ ],
}:
let
  sourceFile = writeTextFile { inherit name text; };
in
writeTextFile {
  name = ".${name}-wrapped";
  executable = true;
  destination = "/bin/${name}";
  text =
    ''
      #!${runtimeShell}
      set -o errexit
      set -o nounset
      set -o pipefail
    ''
    + lib.optionalString (runtimeInputs != [ ]) ''

      export PATH="${lib.makeBinPath runtimeInputs}:$PATH"
    ''
    + ''

      ${babashka-unwrapped}/bin/bb ${sourceFile} "$@"
    '';
}
