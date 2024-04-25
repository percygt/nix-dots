#!/usr/bin/env bash
set -euo pipefail
dots_dir="$HOME/nix-dots"
sec_dir="$HOME/sikreto"

if [ ! -d "$dots_dir/.git" ]; then
	git clone git@gitlab.com:percygt/nix-dots.git "$dots_dir"
fi
sleep 1
if [ ! -d "$sec_dir/.git" ]; then
	git clone git@gitlab.com:percygt/sikreto.git "$sec_dir"
fi
