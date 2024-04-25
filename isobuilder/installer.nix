{
  pkgs,
  targetUser,
  lib,
  libx,
  ...
}: let
  inherit (libx) mkFileList;
  mkShScripts = scripts:
    map (
      script:
        pkgs.writeShellScriptBin (lib.removeSuffix ".sh" script) (builtins.readFile ./scripts/${script})
    )
    scripts;
in {
  environment.systemPackages = with pkgs; [
    (
      writeShellApplication {
        name = "mknixos";

        runtimeInputs =
          [gum rsync age sops yq-go]
          ++ mkShScripts (mkFileList ./scripts);

        text = ''
          if [ "$(id -u)" -eq 0 ]; then
          	echo "ERROR! $(basename "$0") should be run as a regular user"
          	exit 1
          fi

          DOTS_DIR="$HOME/nix-dots";
          MNT="/dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5"
          LUKS="/dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9"

          setCredentials "$MNT"
          cloneDots

          TARGET_USER="${targetUser}"
          TARGET_HOST=$(find "$DOTS_DIR"/profiles/*/configuration.nix | cut -d'/' -f6 | gum choose)

          setSecrets "$TARGET_HOST"
          setDisks "$TARGET_HOST"
          startInstall "$TARGET_HOST" "$TARGET_USER"
          postInstall "$TARGET_HOST" "$TARGET_USER" "$LUKS"
        '';
      }
    )
  ];
}
