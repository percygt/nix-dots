#!/usr/bin/env bash
set -euo pipefail
TARGET_HOST=$1
DOTS_DIR="$HOME/nix-dots"
SECRETS_DIR="$HOME/sikreto"
SYSTEM_AGE="/tmp/system-sops.keyfile"
HOME_AGE="/tmp/home-sops.keyfile"

if [ ! -f "$HOME"/secrets_updated ]; then
  if grep "data.keyfile" "$DOTS_DIR"/profiles/"$TARGET_HOST"/disks.nix; then
    echo -n "$(head -c32 /dev/random | base64)" >/tmp/data.keyfile
  fi

  [ -e "$SYSTEM_AGE" ] || age-keygen -o "$SYSTEM_AGE"
  [ -e "$HOME_AGE" ] || age-keygen -o "$HOME_AGE"

  SYSTEM_AGE_PUBLICKEY=$(cat $SYSTEM_AGE | grep -oP "public key: \K(.*)")
  HOME_AGE_PUBLICKEY=$(cat $HOME_AGE | grep -oP "public key: \K(.*)")

  pushd "$SECRETS_DIR" &>/dev/null

  yq ".keys[.keys[] | select(anchor == \"$TARGET_HOST-system\") | path | .[-1]] = \"$SYSTEM_AGE_PUBLICKEY\"" -i "$SECRETS_DIR/.sops.yaml"
  yq ".keys[.keys[] | select(anchor == \"$TARGET_HOST-home\") | path | .[-1]] = \"$HOME_AGE_PUBLICKEY\"" -i "$SECRETS_DIR/.sops.yaml"

  SOPS_AGE_KEY_FILE="$SYSTEM_AGE" sops updatekeys secrets-system.enc.yaml
  SOPS_AGE_KEY_FILE="$HOME_AGE" sops updatekeys secrets-home.enc.yaml

  git add .
  git commit -m "$TARGET_HOST install/reinstall "
  git push origin main

  popd &>/dev/null

  sleep 2

  pushd "$DOTS_DIR" &>/dev/null

  nix flake update sikreto
  git add .
  git commit -m "$TARGET_HOST install/reinstall"
  git push origin main

  popd &>/dev/null

  touch secrets_updated
fi
