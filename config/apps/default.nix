{ isGeneric, ... }:
if isGeneric then { imports = [ ./home.nix ]; } else { imports = [ ./system.nix ]; }
