{
  pkgs,
  isGeneric,
  ...
}: let
  wezterm =
    if isGeneric
    then pkgs.stash.wezterm_wrapped
    else pkgs.stash.wezterm_nightly;
in {
  home.packages = with pkgs; [
    (i3-quickterm.overrideAttrs
      (oldAttrs: {
        preBuild = ''
          sed -i '/TERMS = {/a\    "wezterm": TERM("${wezterm}/bin/wezterm", titleopt=None),' i3_quickterm/main.py
        '';
      }))
  ];
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
