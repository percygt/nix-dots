{pkgs, ...}: let
  extraNodePackages = import ../../nixpkgs/node {
    inherit pkgs;
    system = pkgs.system;
    nodejs = pkgs.nodejs;
  };
in {
  astro = {
    exe = "prettier";
    args = [
      "--plugin"
      "${extraNodePackages.prettier-plugin-astro}/lib/node_modules/prettier-plugin-astro/dist/index.js"
    ];
  };
  javascript = {
    exe = "denofmt";
  };
  typescript = {
    exe = "denofmt";
  };
  jsx = {
    exe = "denofmt";
    args = ["fmt" "-"];
  };
  tsx = {
    exe = "denofmt";
    args = ["fmt" "-"];
  };
}
