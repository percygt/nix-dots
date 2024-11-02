default:
  @just --list

rh:
	nh home switch -- --accept-flake-config --show-trace

rn:
	nh os switch -- --accept-flake-config --show-trace

ra: rn && rh

ch:
  nix flake check

up:
  nix flake update
  doom sync -u

ur: up && ra
