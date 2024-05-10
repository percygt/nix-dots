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
          name = "my-project";

          imports = [
            ./.module/javascript-pnpm.nix
            # ./client/devenv.nix
            # ./server/devenv.nix
          ];
          # languages.javascript-pnpm = {
          #   enable = true;
          #   package = pkgs.nodejs_20;
          #   pnpm = {
          #     install = {
          #       enable = true;
          #     };
          #   };
          # };
          enterShell = ''
            echo "Starting shell"
          '';
        };
      };
    };
}
