{inputs, ...}:
(import ./common.nix {inherit inputs;}) // (import ./sway.nix {inherit inputs;})
