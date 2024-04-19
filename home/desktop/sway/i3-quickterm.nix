{
  xdg.configFile."i3-quickterm/config.json".text = ''
    {
        "menu": "rofi -dmenu -p 'quickterm: ' -no-custom -auto-select",
        "term": "wezterm",
        "history": "{$HOME}/.cache/i3-quickterm/shells.order",
        "ratio": 1,
        "pos": "top",
        "shells": {
            "js": "node",
            "python": "ipython3 --no-banner",
            "shell": "{$SHELL}"
        }
    }
  '';
}
