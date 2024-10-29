# vim: set ft=make :
default:
  @just --list

update:
  nix flake update
  doom ync -u

rebuild:
  nh os switch -- --accept-flake-config --show-trace
  doom sync

check:
  nix flake check

rebuild-update: update && rebuild
