{ pkgs, inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
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

  tofi-pass =
    pkgs.writers.writeBashBin "tofi-pass"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.tofi
            pkgs.pass
          ]}"
        ];
      }
      #bash
      ''
        shopt -s nullglob globstar
        dmenu="tofi --prompt-text='Passmenu: '"
        prefix=''${PASSWORD_STORE_DIR- ~/.password-store}
        password_files=( "$prefix"/**/*.gpg )
        password_files=( "''${password_files[@]#"$prefix"/}" )
        password_files=( "''${password_files[@]%.gpg}" )
        password=$(printf '%s\n' "''${password_files[@]}" | "$dmenu" "$@")
        [[ -n $password ]] || exit
        pass show -c "$password" 2>/dev/null
      '';

  tofi-power-menu =
    pkgs.writers.writeBashBin "tofipowermenu"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.tofi
            pkgs.systemd
          ]}"
        ];
      }
      #bash
      ''
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
  tmux-launch-session =
    pkgs.writers.writeBashBin "tmuxLaunchSession"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.tmux
          ]}"
        ];
      }
      #bash
      ''
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
  ddapp =
    pkgs.writers.writeBashBin "ddapp" { }
      #bash
      ''
        while getopts p:c: flag
        do
            case "''${flag}" in
                p) pidfname=''${OPTARG};;
                c) command=''${OPTARG};;
            esac
        done
        TERM_PIDFILE="/tmp/$pidfname"
        TERM_PID="$(<"$TERM_PIDFILE")"
        if swaymsg "[ pid=$TERM_PID ] scratchpad show"
        then
            swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
        else
            echo "$$" > "$TERM_PIDFILE"
            swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec $command
        fi
      '';
  wez-wrapped-ddterm =
    pkgs.writers.writeBashBin "wezddterm"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.wezterm_wrapped
          ]}"
        ];
      }
      #bash
      ''
        TERM_PIDFILE="/tmp/wez-ddterm"
        TERM_PID="$(<"$TERM_PIDFILE")"
        if swaymsg "[ pid=$TERM_PID ] scratchpad show"
        then
            swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
        else
            echo "$$" > "$TERM_PIDFILE"
            swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec wezterm
        fi
      '';
  wez-nightly-ddterm =
    pkgs.writers.writeBashBin "wezddterm"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.wezterm
          ]}"
        ];
      }
      #bash
      ''
        TERM_PIDFILE="/tmp/wez-ddterm"
        TERM_PID="$(<"$TERM_PIDFILE")"
        if swaymsg "[ pid=$TERM_PID ] scratchpad show"
        then
            swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
        else
            echo "$$" > "$TERM_PIDFILE"
            swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec wezterm
        fi
      '';
  foot-ddterm =
    pkgs.writers.writeBashBin "footddterm"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.tmux-launch-session
            pkgs.foot
          ]}"
        ];
      }
      #bash
      ''
        TERM_PIDFILE="/tmp/foot-ddterm"
        TERM_PID="$(<"$TERM_PIDFILE")"
        if swaymsg "[ pid=$TERM_PID ] scratchpad show"
        then
            swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
        else
            echo "$$" > "$TERM_PIDFILE"
            swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec foot tmuxLaunchSession
        fi
      '';

  json2nix = pkgs.writeScriptBin "json2nix" ''
    ${pkgs.python3}/bin/python ${
      pkgs.fetchurl {
        url = "https://gitlab.com/-/snippets/3613708/raw/main/json2nix.py";
        hash = "sha256-zZeL3JwwD8gmrf+fG/SPP51vOOUuhsfcQuMj6HNfppU=";
      }
    } $@
  '';

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
