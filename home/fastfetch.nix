{pkgs, ...}: {
  home.packages = [pkgs.fastfetch];
  xdg.configFile = {
    "fastfetch/config.conf" = {
      text = ''
        --structure OS:Kernel:Packages:DE:Terminal:Uptime
        --logo none
        --logo-type none
        --color-keys yellow
        --separator "  "

        # Key options:
        # Sets the displayed key of a module
        # Can be any string. Some of theme take an argument like a format string. See "fastfetch --help format" for help.
        --os-key 
        --kernel-key 
        --uptime-key 󰅶
        --packages-key 󰏔
        --de-key 󰧨
        --wm-key 
        --terminal-key 󰞷

        # Format options:
        # Sets the format string for module values.
        # For information on format strings, see "fastfetch --help format".
        # To see the parameter they take and their default value, see "fastfetch --help *-format", e.g. "fastfetch --help os-format".
        # An empty format string (As they are currently below) will behave as if it was not set.
        --os-format "{2} {9}"
        --terminal-format "{5}"
      '';
    };
  };
}
