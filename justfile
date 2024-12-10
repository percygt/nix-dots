alias r := rebuild
alias ra := rebuild-all
alias ru := rebuild-up
alias upin := update-input
alias c := check

default:
  @just --list --unsorted

diff:
  git diff ':!flake.lock'

check:
  nix flake check -L

backup-to-tmp path="":
  sudo borgmatic extract --archive latest --path {{ path }} --destination /tmp

rebuild config="os" update="":
	nh {{ config }} switch {{ update }} -- --accept-flake-config --show-trace

update-input input:
  nix flake update {{ input }}

rebuild-all update="":
  just rebuild os {{update}} && just rebuild home

rebuild-up:
  just rebuild-all -u
  doom sync -u

clean:
  nh clean all --keep-since 3d --keep 3

isobld profile:
  nix build .#nixosConfigurations.{{profile}}.config.system.build.isoImage
