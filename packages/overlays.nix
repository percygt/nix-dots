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

  backlight-set = pkgs.writeShellApplication {
    name = "backlightset";
    runtimeInputs = [
      pkgs.gawk
      pkgs.brightnessctl
      pkgs.ddcutil
      pkgs.dimland
    ];
    text = ''
      param="''${1:-100}"
      bus_file="$XDG_CACHE_HOME/ddc_buses"
      if [[ "$param" == "min" ]]; then
        brightness=0
      elif [[ "$param" == "max" ]]; then
        brightness=100
      elif [[ "$param" =~ ^[0-9]+$ ]] && [ "$param" -ge 0 ] && [ "$param" -le 100 ]; then
        brightness="$param"
      else
        echo "Invalid brightness value: '$param'"
        echo "Usage: $0 [min|max|0-100]"
        exit 1
      fi

      if [[ ! -s "$bus_file" ]]; then
        ddcutil detect --brief | awk '
          BEGIN { RS=""; FS="\n" }
          /^Display/ {
            for (i = 1; i <= NF; i++) {
              if ($i ~ /I2C bus:/) match($i, /\/dev\/i2c-([0-9]+)/, a)
              if ($i ~ /DRM connector:/) match($i, /card[0-9]+-([A-Z0-9-]+)/, b)
            }
            if (a[1]) print a[1], b[1]
          }
        ' > "$bus_file"
      fi

      # === Calculate Derived Values ===
      ext_brightness=$(awk "BEGIN { print ($brightness < 30) ? 0 : int((($brightness - 30)/70)*70) }")
      dim_opacity=$(awk "BEGIN { printf \"%.2f\", ($brightness >= 30) ? 0 : 0.9 * (1 - ($brightness / 30)) }")
      safe_brightness=$(awk "BEGIN { print ($brightness <= 0) ? 1 : $brightness }")

      # === Apply to External Monitors ===
      while read -r bus display; do
        ddcutil --bus "$bus" setvcp 10 "$ext_brightness" &>/dev/null
        if [[ "$brightness" -gt 30 ]]; then
          dimland stop
        elif [[ -n "$display" ]]; then
          dimland -a "$dim_opacity" -o "$display"
        fi
      done < "$bus_file"

      brightnessctl set "''${safe_brightness}"% > /dev/null 2>&1
    '';
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
