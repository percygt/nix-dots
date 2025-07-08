{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._base;
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

        TARGET_HOST=$(find "$DOTS_DIR"/profiles/*/configuration.nix | cut -d'/' -f6 | gum choose)
        export TARGET_HOST
        export TARGET_USER=${g.systemInstall.targetUser}
        export FLAKE=${g.flakeDirectory}
        export SECRETS=${g.secretsDirectory}
        export DATA=${g.dataDirectory}
        export WINDOWS=${g.windowsDirectory}
        export MOUNT_DEVICE=${g.systemInstall.mountDevice};
        export LUKS_DEVICE=${g.systemInstall.luksDevice};
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
