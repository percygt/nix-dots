{ pkgs }:
(import ./derivations.nix { inherit pkgs; })
// {
  success-alert = pkgs.fetchurl {
    # https://freesound.org/people/Rob_Marion/sounds/541981/
    url = "https://cdn.freesound.org/previews/541/541981_6856600-lq.mp3";
    sha256 = "042snm79z71djc862b2vy3wxdl0jhcbj3dx6hxf0wcyjqrrkwv1l";
  };
  normal-alert = pkgs.fetchurl {
    # https://freesound.org/people/yfjesse/sounds/235911/
    url = "https://cdn.freesound.org/previews/235/235911_2391840-lq.mp3";
    sha256 = "149jb8b61ax9a8yk1hx8kmy9i5yi0csv4jka508zw1gsgmx1zg2b";
  };
  failure-alert = pkgs.fetchurl {
    # https://freesound.org/people/rhodesmas/sounds/342756/
    url = "https://cdn.freesound.org/previews/342/342756_5260872-lq.mp3";
    sha256 = "1kklbi5sxp7capkf9z3f85nrly14lg6kn822qv3gpiskcnfxqsii";
  };
  pomo-alert = pkgs.fetchurl {
    # https://freesound.org/people/dersinnsspace/sounds/421829/
    url = "https://cdn.freesound.org/previews/421/421829_8224400-lq.mp3";
    sha256 = "049x6z6d3ssfx6rh8y11var1chj3x67nfrakigydnj3961hnr6ar";
  };
  # babashka script source: https://github.com/stelcodes/nixos-config/commit/95d8734bad6162157f92f77951215c0aaa6b71d2
  writeBabashkaScript = pkgs.callPackage ./clj/writeBabashkaScript.nix { };
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

  tofi-power-menu = pkgs.writeShellApplication {
    name = "tofi-power-menu";
    runtimeInputs = [
      pkgs.tofi
      pkgs.systemd
    ];
    text = ''
      case $(printf "%s\n" "Power Off" "Restart" "Suspend" "Log Out" | tofi --prompt-text="Power Menu: ") in
      "Power Off")
        systemctl poweroff
        ;;
      "Restart")
        systemctl reboot
        ;;
      "Suspend")
        systemctl suspend
        ;;
      "Log Out")
        swaymsg exit
        ;;
      esac
    '';
  };

  json2nix = pkgs.writeScriptBin "json2nix" ''
    ${pkgs.python3}/bin/python ${
      pkgs.fetchurl {
        url = "https://gitlab.com/-/snippets/3613708/raw/main/json2nix.py";
        hash = "sha256-zZeL3JwwD8gmrf+fG/SPP51vOOUuhsfcQuMj6HNfppU=";
      }
    } $@
  '';

  tofi-pass = pkgs.writeShellApplication {
    name = "tofi-pass";
    runtimeInputs = [
      pkgs.tofi
      pkgs.pass
    ];
    text = ''
      shopt -s nullglob globstar
      prefix=''${PASSWORD_STORE_DIR- ~/.password-store}
      password_files=( "$prefix"/**/*.gpg )
      password_files=( "''${password_files[@]#"$prefix"/}" )
      password_files=( "''${password_files[@]%.gpg}" )
      password=$(printf '%s\n' "''${password_files[@]}" | tofi --prompt-text='Passmenu: ')
      [[ -n $password ]] || exit
      pass show -c "$password" 2>/dev/null
    '';
  };

  toggle-service = pkgs.writeShellApplication {
    name = "toggle-service";
    runtimeInputs = [ pkgs.systemd ];
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
