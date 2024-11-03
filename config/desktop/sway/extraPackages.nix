{ pkgs, config, ... }:
let
  g = config._general;
in
{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "foot-ddterm";
      runtimeInputs = [
        pkgs.tmux-launch-session
        g.terminal.foot.package
      ];
      text = ''
        TERM_PIDFILE="/tmp/foot-ddterm"
        TERM_PID="$(<"$TERM_PIDFILE")"
        if swaymsg "[ pid=$TERM_PID ] scratchpad show"
        then
            swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
        else
            echo "$$" > "$TERM_PIDFILE"
            swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec foot tmux-launch-session
        fi
      '';
    })
    (writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [
        tesseract
        grim
        slurp
        coreutils
      ];
      text = ''
        echo "Generating a random ID..."
        id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
        echo "Image ID: $id"

        echo "Taking screenshot..."
        grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr-"$id".png

        echo "Running OCR..."
        tesseract /tmp/ocr-"$id".png - | wl-copy
        echo -en "File saved to /tmp/ocr-'$id'.png\n"

        echo "Sending notification..."
        notify-send -i diodon "OCR " "Text copied!"

        echo "Cleaning up..."
        rm /tmp/ocr-"$id".png -vf
      '';
    })
    polkit_gnome
    swayidle
    brightnessctl
    autotiling
    grim
    kanshi
    libnotify
    pamixer
    wev
    slurp
    wdisplays
    wl-clipboard
    ydotool
    xdg-utils
    xwayland
    wl-screenrec
    libnotify
  ];
}
