{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
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

        export DOTS_DIR="$HOME/nix-dots";
        export SEC_DIR="$HOME/sikreto"
        export TARGET_USER=${g.username}
        export TARGET_HOST=$(find "$DOTS_DIR"/profiles/*/configuration.nix | cut -d'/' -f6 | gum choose)
        export FLAKE=${g.flakeDirectory}
        export SECRETS=${g.secretsDirectory}
        export DATA=${g.dataDirectory}
        export WINDOWS=${g.windowsDirectory}
        export MOUNT_DEVICE="/dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5";
        export LUKS_DEVICE="/dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9"
        export SYSTEM_AGE="/tmp/system-sops.keyfile"
        export HOME_AGE="/tmp/home-sops.keyfile"

        setCredentials
        cloneDots
        setSecrets
        setDisks
        startInstall
        postInstall
      '';
    })
  ];
}
