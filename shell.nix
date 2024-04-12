{pkgs, ...}: {
  default = let
    json2nix = pkgs.writeScriptBin "json2nix" ''
      ${pkgs.python3}/bin/python ${pkgs.fetchurl {
        url = "https://gitlab.com/-/snippets/3613708/raw/main/json2nix.py";
        hash = "sha256-zZeL3JwwD8gmrf+fG/SPP51vOOUuhsfcQuMj6HNfppU=";
      }} $@
    '';
    yaml2nix = pkgs.writeScriptBin "yaml2nix" ''
      nix run github:euank/yaml2nix '.args'
    '';
  in
    pkgs.mkShell {
      packages = with pkgs; [
        yaml2nix
        json2nix
        node2nix
        sops
        statix
        deadnix
        alejandra
        git
        sops
        ssh-to-age
        gnupg
        age
      ];
    };
}
