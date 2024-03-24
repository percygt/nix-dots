{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bin.pmenu.enable =
      lib.mkEnableOption "Enable pmenu";
  };

  config = lib.mkIf config.bin.pmenu.enable {
    home.packages = with pkgs; [
      (
        writeShellScriptBin
        "pmenu"
        /*
        bash
        */
        ''
          PASSWORD_STORE_DIR="''${PASSWORD_STORE_DIR:-$HOME/.local/share/password-store}"
          USERNAME=$(whoami)

          cmd_clip_usage() {
              cat <<-_EOF
              Usage:
              $PROGRAM clip [options]
                  Provide an interactive solution to copy passwords to the
                  clipboard. It will show all pass-names in fzf, waits for the user
          	to select one then copies it to the clipboard.

          _EOF
              exit 0
          }

          cmd_clip_short_usage() {
              echo "Usage: $PROGRAM $COMMAND [--help,-h]"
          }

          command_exists() {
              command -v "$1" >/dev/null 2>&1 || exit 1
          }

          cmd_clip() {
              local opts fzf=0
              local err=$?
              # Parse arguments
              if command_exists fzf; then
                  fzf=1
              fi

              [[ $err -ne 0 ]] && die "$(cmd_clip_short_usage)"

              # Figure out if we use fzf
              local prompt='Search Query :: '
              local fzf_cmd="fzf --print-query --prompt=\"$prompt\" -i --no-mouse"

              if [ -n "$term" ]; then
                fzf_cmd="$fzf_cmd -q\"$term\""
              fi

              fzf_cmd="$fzf_cmd | tail -n1"

              if [[ $fzf = 1 ]]; then
                  command_exists fzf || die "Could not find fzf in \$PATH"
                  menu="$fzf_cmd"
              fi

              cd "$PASSWORD_STORE_DIR" || die "Could not locate password store directory. Please ensure \$PASSWORD_STORE_DIR is setup."

              # Select a passfile
              passfile=$(
                  cd $PASSWORD_STORE_DIR  \
                  && fd --type f          \
                  | sed -e 's/.gpg$//'    \
                  | sort                  \
                  | eval "$menu" )

              # If no pass file was selected by the user, exit the program with an error
              if [ -z "$passfile" ]; then
                  die 'No passfile selected.'
              fi

              # Either copy existing one or generate a new one
              if ls "$passfile.gpg" > /dev/null 2>&1; then
                  pass "$passfile" --clip || exit 1
              fi
          }

          [[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]] && cmd_clip_usage

          cmd_clip "$@"
        ''
      )
    ];
  };
}
