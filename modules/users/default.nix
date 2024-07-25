{ isGeneric, username, ... }: if (!isGeneric) then { imports = [ ./${username}.nix ]; } else { }
