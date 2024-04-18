{
  config,
  libx,
  ...
}: let
  inherit (libx) colors fonts;
in {
  services = {
    mako = {
      enable = true;
      anchor = "bottom-right";
      font = "GeistMono Nerd Font 10";
      extraConfig = ''
        sort=-time
        layer=overlay
        width=300
        height=110
        border-radius=5
        icons=1
        max-icon-size=64
        default-timeout=7000
        ignore-timeout=1
        padding=14
        margin=20
        background-color=#${colors.default.background}

        [urgency=low]
        border-color=#${colors.default.foreground}
        [urgency=normal]
        border-color=#${colors.normal.yellow}

        [urgency=high]
        border-color=#${colors.normal.red}

        [mode=hidden]
        invisible=1
      '';
    };
    # mako = {
    #   enable = true;
    #   actions = true;
    #   anchor = "top-right";
    #   borderRadius = 8;
    #   borderSize = 1;
    #   defaultTimeout = 10000;
    #   font = config.gtk.font.name;
    #   iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
    #   icons = true;
    #   layer = "overlay";
    #   maxVisible = 3;
    #   padding = "10";
    #   width = 300;
    #
    #   backgroundColor = "${colors.default.background}";
    #   borderColor = "${colors.highlight.background}";
    #   progressColor = "over ${colors.default.foreground}";
    #   textColor = "${colors.highlight.foreground}";
    #
    #   extraConfig = ''
    #     [urgency=hgh]
    #     border-color=${colors.bold}
    #   '';
    # };
  };
}
