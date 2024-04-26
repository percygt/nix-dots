{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.infosec.keepass.enable {
    home.packages = with pkgs; [
      (
        writeShellScriptBin
        "kpass"
        /*
        bash
        */
        ''
          check_dep () {
              for dep; do
          	if ! command -v "$dep" 1>/dev/null; then
          	    printf "%s is not installed\n" "$dep" 1>&2
          	    exit 1
          	fi
              done
              unset dep
          }

          check_dep "keepassxc-cli" "fzf"

          # Also exit if KPDB is empty
          if [ -z "$KPDB" ]; then
              printf "Please set \$KPDB before running\n" 1>&2
              exit 1
          fi

          usage() {
              cat << EOF
          usage: $(basename "$0") [options]

          List all password entries in $KPDB using fzf.

          OPTIONS:

            -h, --help:  this help message
            -s, --shell: enter interactive mode

          EOF
              exit
          }

          list_entries() {
              echo "$passwd" | \
                  keepassxc-cli ls -q -R -f "$KPDB" ''${KEYF+-k $KEYF} | \
                  # Remove recycle bin, group path and non-file entries
                  awk '!/Recycle Bin/' | awk -F/ '!/\/$/{print $NF}'
          }

          open_url() {
              tmp="$selection"
              echo "$passwd" | \
                  keepassxc-cli show -q "$KPDB" ''${KEYF+-k $KEYF} "$selection" -a URL | xargs xdg-open
          }

          clip_attribute() {
              # defaults to no timeout, but set one when copying passwords
              local timeout="''${2-0}"
              tmp="$selection"
              echo "$passwd" | \
                  keepassxc-cli clip "$KPDB" ''${KEYF+-k $KEYF} -a "$1" "$selection" "$timeout"
          }

          prompt() {
              read -r -p "Enter $1: " input >&2
              printf "'%s'" "$input"
          }

          add_entry() {
              local entry title user url notes
              declare -a arr=("entry" "title" "user" "url" "notes")
              for i in "''${arr[@]}"
              do
                  eval "$i"="$(prompt "$i")"
              done

              if [ -n "$entry"  ]; then
                  echo "$passwd" | \
                      keepassxc-cli add -q \
                                    --username "$user" \
                                    --url "$url" \
                                    --notes "$notes" \
                                    -g "$KPDB" ''${KEYF+-k $KEYF} "$entry"
                  echo "$passwd" | \
                      keepassxc-cli edit -q -t "$title" "$KPDB" ''${KEYF+-k $KEYF} "$entry"
                  echo "$entry added"
              else
                  exit 1
              fi
          }

          remove_entry() {
              tmp="$selection"
              while true; do
                  read -r -p "Remove $selection (y/n)? " yn
                  case $yn in
                      [Yy]* ) echo "$passwd" | \
                                    keepassxc-cli rm -q "$KPDB" ''${KEYF+-k $KEYF} "$selection"
                              echo "$selection removed"
                              exit;;
                      [Nn]* ) exit;;
                      * ) echo "Please answer yes or no.";;
                  esac
              done
          }

          print_help() {
              tmp="$selection"
              fzf --sync --ansi --phony --no-info \
                  --bind q:accept \
                  --header "Press q to close" \
                  --query "''${tmp}" \
                  < <(
                  printf "Alt-u \t open URL\n"
                  printf "Alt-b \t copy username\n"
                  printf "Alt-c \t copy password\n"
                  printf "Alt-a \t add new entry\n"
                  printf "Alt-r \t remove selected entry\n"
                  printf "Alt-h \t show help menu\n"
                  printf "Ctrl-c \t exit\n"
              )
          }

          if [ $# -eq 0 ]; then

              if [ -s "$PASSFILE" ]; then
                  passwd=$(gpg --decrypt "$PASSFILE" 2> /dev/null)
              else
                  IFS= read -r -s -p "Enter Password to unlock $KPDB: " passwd
              fi

              check_credentials=$(list_entries)

              # Only run fzf if credentials are valid
              if [ -n "$check_credentials" ]
              then
                  main() {
                      while :; do
                          clear
                          selection=$(list_entries |
                                          fzf --bind "alt-u:execute(echo 'URL' > /tmp/passarg)+accept" \
                                              --bind "alt-b:execute(echo 'username' > /tmp/passarg)+accept" \
                                              --bind "alt-c:execute(echo 'password' > /tmp/passarg)+accept" \
                                              --bind "alt-a:execute(echo 'add' > /tmp/passarg)+accept" \
                                              --bind "alt-r:execute(echo 'rm' > /tmp/passarg)+accept" \
                                              --bind "ctrl-c:execute(echo 'quit' > /tmp/passarg)+abort" \
                                              --bind "ctrl-g:execute(echo 'quit' > /tmp/passarg)+abort" \
                                              --bind "esc:execute(echo 'quit' > /tmp/passarg)+abort" \
                                              --bind "alt-h:execute(echo 'help' > /tmp/passarg)+accept" \
                                              --layout reverse \
                                              --no-bold \
                                              --query "''${tmp}" \
                                              --header "Alt-h for help" \
                                              --no-multi \
                                              --cycle
                                   )
                                  # --preview "echo $passwd | keepassxc-cli show -q $KPDB ''${KEYF+-k $KEYF} {}" \
                                      if [[ -f "/tmp/passarg" ]]; then
                                          arg=$(cat /tmp/passarg)
                                          rm /tmp/passarg
                                      fi

                                      if ! [[ -v "$selection" ]]; then
                                          clear
                                          case "$arg" in
                                              URL)
                                                  open_url
                                                  continue
                                                  ;;
                                              username)
                                                  clip_attribute username
                                                  continue
                                                  ;;
                                              password)
                                                  clip_attribute password 5
                                                  continue
                                                  ;;
                                              add)
                                                  add_entry
                                                  exit
                                                  ;;
                                              rm)
                                                  remove_entry
                                                  ;;
                                              help)
                                                  print_help
                                                  continue
                                                  ;;
                                              quit)
                                                  exit
                                                  ;;
                                          esac
                                      fi
                      done
                  }

                  main
                  unset -v passwd

              else
                  printf -- "\nInvalid credentials. Please try again\n"
              fi
          else
              while [ ! $# -eq 0 ]; do
          	case "$1" in
          	    --shell | -s)
          		keepassxc-cli open "$KPDB" ''${KEYF+-k $KEYF}
          		;;
                      --help | -h)
          		usage
          		;;
          	esac
          	shift
              done
          fi

        ''
      )
    ];
  };
}
