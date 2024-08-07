#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$DOTS_DIR/.git" ]; then
  git clone git@gitlab.com:percygt/nix-dots.git "$DOTS_DIR"
fi
sleep 1
if [ ! -d "$SEC_DIR/.git" ]; then
  git clone git@gitlab.com:percygt/sikreto.git "$SEC_DIR"
fi
