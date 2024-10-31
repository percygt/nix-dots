default:
  @just --list

update:
  nix flake update
  doom sync -u

rh:
	nh home switch -- --accept-flake-config --show-trace

rn:
	nh os switch -- --accept-flake-config --show-trace

ra: rn && rh

rebuild:
  nh os switch -- --accept-flake-config --show-trace
  doom sync

check:
  nix flake check

rebuild-update: update && rebuild
