{lib}: let
  wsToKey = ws: builtins.substring 0 1 ws;
in rec {
  package = {pkgs}:
    pkgs.swayfx.override {
      inherit (pkgs) swayfx-unwrapped;
    };

  tofipass = {pkgs}:
    pkgs.writers.writeBash "tofipass" ''
      shopt -s nullglob globstar
      dmenu="${pkgs.tofi}/bin/tofi"
      prefix=''${PASSWORD_STORE_DIR- ~/.password-store}
      password_files=( "$prefix"/**/*.gpg )
      password_files=( "''${password_files[@]#"$prefix"/}" )
      password_files=( "''${password_files[@]%.gpg}" )
      password=$(printf '%s\n' "''${password_files[@]}" | ${pkgs.tofi}/bin/tofi  --prompt-text="Passmenu: " | xargs swaymsg exec --)
      [[ -n $password ]] || exit
      pass show -c "$password" 2>/dev/null
    '';
  dropdown-terminal = {
    pkgs,
    weztermPackage,
  }:
    pkgs.writers.writeBash "dropdown_terminal" ''
      TERM_PIDFILE="/tmp/wezterm-dropdown"
      TERM_PID="$(<"$TERM_PIDFILE")"
      if swaymsg "[ pid=$TERM_PID ] scratchpad show"
      then
          swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
      else
          echo "$$" > "$TERM_PIDFILE"
          swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
          exec "${weztermPackage}/bin/wezterm";
      fi
    '';
  toggle-blur = {pkgs}:
    pkgs.writers.writeBash "toggle-blur" ''
      BLUR_STATUS_FILE="/tmp/blur-status"
      BLUR_STATUS=$(<"$BLUR_STATUS_FILE" :- 0)
      # BLUR_STATUS=$(<"$BLUR_STATUS_FILE")
      if [ ! -f "$BLUR_STATUS_FILE" ]; then
          echo "1" > "$BLUR_STATUS_FILE"
          # swaymsg "blur 1"
      else
          # swaymsg "blur $BLUR_STATUS"
          echo $((1 - BLUR_STATUS)) > "$BLUR_STATUS_FILE"
      fi
      swaymsg "blur $BLUR_STATUS"
    '';
  power-menu = {pkgs}:
    pkgs.writers.writeBash "power-menu" ''
      case $(printf "%s\n" "Power Off" "Restart" "Suspend" "Lock" "Log Out" | ${pkgs.tofi}/bin/tofi  --prompt-text="Power Menu: ") in
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
  mkWorkspaceKeys = mod: workspaces:
    builtins.listToAttrs ((map (ws: {
          name = mod + "+" + wsToKey ws;
          value = "workspace ${ws}";
        })
        workspaces)
      ++ (map (ws: {
          name = mod + "+Shift+" + wsToKey ws;
          value = "move container to workspace ${ws}";
        })
        workspaces));

  mkDirectionKeys = mod: keypairs:
    builtins.listToAttrs (
      (map (v: {
        name = mod + "+" + keypairs.${v};
        value = "focus ${v}";
      }) (builtins.attrNames keypairs))
      ++ (map (v: {
        name = mod + "+Shift+" + keypairs.${v};
        value = "move ${v}";
      }) (builtins.attrNames keypairs))
      ++ (map (v: {
        name = mod + "+Ctrl+" + keypairs.${v};
        value = "move workspace output ${v}";
      }) (builtins.attrNames keypairs))
    );

  mapApps = {
    command,
    crit_name,
    crits,
  }:
    map (
      crit: {
        inherit command;
        criteria = {
          ${crit_name} = crit;
        };
      }
    )
    crits;
  mkAppsFloat = {
    app_ids ? null,
    classes ? null,
    titles ? null,
    w ? 80,
    h ? 80,
    command ? ''floating enable, resize set width ${toString w} ppt height ${toString h} ppt'',
  }:
    lib.optionals (app_ids != null) (mapApps {
      inherit command;
      crit_name = "app_id";
      crits = app_ids;
    })
    ++ lib.optionals (classes != null) (mapApps {
      inherit command;
      crit_name = "class";
      crits = classes;
    })
    ++ lib.optionals (titles != null) (mapApps {
      inherit command;
      crit_name = "title";
      crits = titles;
    });
}
