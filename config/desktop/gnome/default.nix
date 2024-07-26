{ isGeneric, ... }: if isGeneric then { imports = [ ./home ]; } else { imports = [ ./system.nix ]; }
