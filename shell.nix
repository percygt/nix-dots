# Shell for bootstrapping flake-enabled nix and other tooling
{
  checks,
  pkgs ? (import ./packages/nixpkgs.nix) { },
  ...
}:
{
  default = pkgs.mkShell {
    name = "percygt-flake";
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    inherit (checks.pre-commit-check) shellHook;
    buildInputs = checks.pre-commit-check.enabledPackages;
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      nh
      git
      just
      age
      ssh-to-age
      sops
    ];
  };
}
