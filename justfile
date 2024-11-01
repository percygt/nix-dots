default:
  @just --list

rh:
	nh home switch -- --accept-flake-config --show-trace

rn:
	nh os switch -- --accept-flake-config --show-trace

ra: rn && rh

check:
  nix flake check

update:
  nix flake update
  doom sync -u

rebuild-update: update && ra
