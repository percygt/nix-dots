{
  pkgs,
  targetUser,
  lib,
  ...
}: let
  mkSh = scripts:
    map (script:
      pkgs.writeShellApplication {
        name = lib.removeSuffix ".sh" script;
        text = builtins.readFile ./scripts/installer/${script};
      })
    scripts;
in {
  environment.systemPackages = with pkgs; [
    (
      writeShellApplication {
        name = "mknixos";
        runtimeInputs =
          [
            gum
            rsync
            age
            sops
            yq-go
          ]
          ++ mkSh (builtins.attrNames (builtins.readDir ./scripts/installer));

        text = ''
          if [ "$(id -u)" -eq 0 ]; then
          	echo "ERROR! $(basename "$0") should be run as a regular user"
          	exit 1
          fi

          DOTS="$HOME/nix-dots";
          MNT="/dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5"
          LUKS="/dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9"

          gum confirm  --default=true \
            "Confirm that you have mounted your drive for credential setup."

          setCredentials "$MNT"

          cloneDots

          TARGET_USER="${targetUser}"
          TARGET_HOST=$(find "$DOTS"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v "iso" | gum choose)

          setSecrets "$TARGET_HOST"
          setDisks "$TARGET_HOST"
          startInstall "$TARGET_HOST" "$TARGET_USER"
          postInstall "$TARGET_HOST" "$TARGET_USER" "$MNT" "$LUKS"
        '';
      }
    )
  ];
}
