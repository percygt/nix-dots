{ isGeneric, ... }: if (!isGeneric) then { imports = [ ./system.nix ]; } else { }
