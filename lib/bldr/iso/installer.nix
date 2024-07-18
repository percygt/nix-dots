{
  pkgs,
  targetUser,
  lib,
  ...
}:
let
  mkPathList = dir: builtins.attrNames (builtins.readDir dir);
  mkBashScriptsFromList =
    scripts:
    map (
      script:
      pkgs.writeShellScriptBin (lib.removeSuffix ".bash" script) (builtins.readFile ./scripts/${script})
    ) scripts;
in
{
  services.udisks2.enable = true;
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "mknixos";

      runtimeInputs =
        (with pkgs; [
          gum
          rsync
          age
          sops
          yq-go
          udisks
        ])
        ++ mkBashScriptsFromList (mkPathList ./scripts);

      text = ''
        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        DOTS_DIR="$HOME/nix-dots";

        # my usb drive with gpg keys inside
        MNT="/dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5"
        LUKS="/dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9"

        setCredentials "$MNT"
        cloneDots
        TARGET_USER=${targetUser}
        TARGET_HOST=$(find "$DOTS_DIR"/profiles/*/configuration.nix | cut -d'/' -f6 | gum choose)
        setSecrets "$TARGET_HOST"
        setDisks "$TARGET_HOST"
        startInstall "$TARGET_HOST" "$TARGET_USER"
        postInstall "$TARGET_HOST" "$TARGET_USER" "$LUKS"
      '';
    })
  ];
}
