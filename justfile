# default recipe to display help information
default:
  @just --list

update:
  nix flake update
  doom sync -u

rebuild:
  nh os switch -- --accept-flake-config --show-trace
  doom sync

rebuild-update: update && rebuild
