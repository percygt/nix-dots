{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

      perSystem = {...}: {
        devenv.shells.default = {
          name = "stashee dev";

          imports = [
            ./.module/javascript-pnpm.nix
            ./.module/python-with-relative-path.nix
            ./client/devenv.nix
            ./server/devenv.nix
          ];
          process.implementation = "process-compose";
          process-managers.process-compose.enable = true;
          enterShell = ''
            echo "Starting server . . .";
          '';
        };
      };
    };
}
