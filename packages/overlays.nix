{ pkgs }:
(import ./derivations.nix { inherit pkgs; })
// {
  success-alert = pkgs.fetchurl {
    # https://freesound.org/people/martcraft/sounds/651624/
    url = "https://cdn.freesound.org/previews/651/651624_14258856-lq.mp3";
    sha256 = "urNwmGEG2YJsKOtqh69n9VHdj9wSV0UPYEQ3caEAF2c=";
  };
  failure-alert = pkgs.fetchurl {
    # https://freesound.org/people/martcraft/sounds/651625/
    url = "https://cdn.freesound.org/previews/651/651625_14258856-lq.mp3";
    sha256 = "XAEJAts+KUNVRCFLXlGYPIJ06q4EjdT39G0AsXGbT2M=";
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
      case $(printf "%s\n" "Power Off" "Restart" "Suspend" "Lock" "Log Out" | tofi --prompt-text="Power Menu: ") in
      "Power Off")
        systemctl poweroff
        ;;
      "Restart")
        systemctl reboot
        ;;
      "Suspend")
        systemctl suspend
        ;;
      "Lock")
        swaylock
        ;;
      "Log Out")
        swaymsg exit
        ;;
      esac
    '';
  };

  tmux-launch-session = pkgs.writeShellApplication {
    name = "tmux-launch-session";
    runtimeInputs = [
      pkgs.tmux
    ];
    text = ''
      if [ -d $FLAKE ]; then
        tmux has-session -t nix-dots 2>/dev/null
        if [ $? != 0 ]; then
          tmux new-session -ds nix-dots -c "$FLAKE"
        fi
        tmux new-session -As nix-dots
      else
        tmux has-session -t home 2>/dev/null
        if [ $? != 0 ]; then
          tmux new-session -ds home -c "$HOME"
        fi
        tmux new-session -As home
      fi
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
