{pkgs ? (import ./nixpkgs.nix) {}}:
(import ./. {inherit pkgs;})
// {
  # babashka script source: https://github.com/stelcodes/nixos-config/commit/95d8734bad6162157f92f77951215c0aaa6b71d2
  writeBabashkaScript = pkgs.callPackage ./clj/writeBabashkaScript.nix {};

  cycle-pulse-sink = pkgs.writeBabashkaScript {
    name = "cycle-pulse-sink";
    text = builtins.readFile ./clj/cycle-pulse-sink.clj;
    runtimeInputs = [pkgs.pulseaudioFull];
  };
  cycle-sway-output = pkgs.writeBabashkaScript {
    name = "cycle-sway-output";
    text = builtins.readFile ./clj/cycle-sway-output.clj;
  };
  cycle-sway-scale = pkgs.writeBabashkaScript {
    name = "cycle-sway-scale";
    text = builtins.readFile ./clj/cycle-sway-scale.clj;
  };
  toggle-sway-window = pkgs.writeBabashkaScript {
    name = "toggle-sway-window";
    text = builtins.readFile ./clj/toggle-sway-window.clj;
  };

  nodePackages-extra = import ./node rec {
    inherit pkgs;
    inherit (pkgs) system;
    nodejs = pkgs.nodejs_20;
  };

  json2nix = pkgs.writeScriptBin "json2nix" ''
    ${pkgs.python3}/bin/python ${pkgs.fetchurl {
      url = "https://gitlab.com/-/snippets/3613708/raw/main/json2nix.py";
      hash = "sha256-zZeL3JwwD8gmrf+fG/SPP51vOOUuhsfcQuMj6HNfppU=";
    }} $@
  '';

  toggle-service = pkgs.writeShellApplication {
    name = "toggle-service";
    runtimeInputs = [pkgs.systemd];
    text = ''
      SERVICE="$1.service"
      if ! systemctl --user cat "$SERVICE" &> /dev/null; then
        echo "ERROR: Service does not exist"
        exit 1
      fi
      if systemctl --user is-active "$SERVICE"; then
        echo "Stopping service"
        systemctl --user stop "$SERVICE"
      else
        echo "Starting service"
        systemctl --user start "$SERVICE"
      fi
    '';
  };
}
