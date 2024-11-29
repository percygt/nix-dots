{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux-launch-session
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
    stable.wl-screenrec
    libnotify
  ];
}
