{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "setagekey" ''
        TARGET_HOST=$1
        dots_dir="$HOME/nix-dots";
        sec_dir="$HOME/sikreto";

        [ -e "/tmp/system-sops.keyfile" ] || age-keygen -o "/tmp/system-sops.keyfile"
        [ -e "/tmp/home-sops.keyfile" ] || age-keygen -o "/tmp/home-sops.keyfile"

        pushd $sec_dir &> /dev/null;

        system_age="/tmp/system-sops.keyfile"
        system_age_pubkey=$(cat $system_age |grep -oP "public key: \K(.*)")
        yq ".keys[.keys[] | select(anchor == '$TARGET_HOST-system') | path | .[-1]] = \"$system_age_pubkey\"" -i "$sec_dir/.sops.yaml"
        SOPS_AGE_KEY_FILE="$system_age" sops updatekeys system-secrets.enc.yaml

        home_age="/tmp/home-sops.keyfile"
        home_age_pubkey=$(cat $home_age |grep -oP "public key: \K(.*)")
        yq ".keys[.keys[] | select(anchor == '$TARGET_HOST-home') | path | .[-1]] = \"$home_age_pubkey\"" -i "$sec_dir/.sops.yaml"
        SOPS_AGE_KEY_FILE="$home_age" sops updatekeys home-secrets.enc.yaml

        git add .
        git commit -m "$TARGET_HOST install/reinstall "
        git push origin main

        popd &> /dev/null;

        sleep 2

        pushd $dots_dir &> /dev/null;

        nix flake lock --update-input sikreto
        git add .
        git commit -m "$TARGET_HOST install/reinstall "
        git push origin main

        popd &> /dev/null;

        touch secrets_updated
      ''
    )
  ];
}
