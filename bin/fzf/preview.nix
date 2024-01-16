{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "preview"
      /*
      bash
      */
      ''
        REVERSE="\x1b[7m"
        RESET="\x1b[m"

        # Ignore if an empty path is given
        [[ -z $1 ]] && exit

        IFS=':' read -r -a INPUT <<<"$1"
        FILE=''${INPUT[0]}
        CENTER=''${INPUT[1]}

        if [[ "$1" =~ ^[A-Za-z]:\\ ]]; then
        	FILE=$FILE:''${INPUT[1]}
        	CENTER=''${INPUT[2]}
        fi

        if [[ -n "$CENTER" && ! "$CENTER" =~ ^[0-9] ]]; then
        	exit 1
        fi
        CENTER=''${CENTER/[^0-9]*/}

        FILE="''${FILE/#\~\//$HOME/}"
        if [ ! -r "$FILE" ]; then
          echo "File not found ''${FILE}"
          exit 1
        fi
        if [ "$CENTER" = "" ]; then
          CENTER=0
        fi

        BATNAME="${bat}/bin/bat"
        if [ -L "$FILE" ]; then
          # Notify the user and recurse on the target of the symlink
          target_path=''$(realpath "$FILE")
          printf "\033[33m'%s' is a symlink to '%s'.\033[0m\n" "$FILE" "$target_path"
          exit $?
        elif [ -f "$FILE" ]; then
          "$BATNAME" --style="''${BAT_STYLE:-numbers}" --color=always --pager=never \
            --highlight-line="$CENTER" -- "$FILE"
          exit $?
        elif [ -d "$FILE" ]; then
          command eza --sort type --icons -F -H --group-directories-first -1 "$FILE"
          exit $?
        else
          echo "$FILE doesn't exist." >&2
        fi
        FILE_LENGTH=''${#FILE}
        MIME=''$(file --dereference --mime -- "$FILE")
        if [[ "''${MIME:FILE_LENGTH}" =~ binary ]]; then
          echo "$MME"
          exit 0
        fi

        DEFAULT_COMMAND="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
        CMD=''${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
        CMD=''${CMD//{\}/$(printf %q "$FILE")}

        eval "$CMD" 2>/dev/null | awk "{ \
            if (NR == $CENTER) \
                { gsub(/\x1b[[0-9;]*m/, \"&$REVERSE\"); printf(\"$REVERSE%s\n$RESET\", \$0); } \
            else printf(\"$RESET%s\n\", \$0); \
            }"
      '')
  ];
}
