{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.dev.enable {
    home.packages = with pkgs; [
      process-compose # Simple and flexible scheduler and orchestrator to manage non-containerized applications
    ];

    xdg.configFile = {
      "process-compose/theme.yaml".source = "${
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "process-compose";
          rev = "b0c48aa07244a8ed6a7d339a9b9265a3b561464d";
          hash = "sha256-uqJR9OPrlbFVnWvI3vR8iZZyPSD3heI3Eky4aFdT0Qo=";
        }
      }/themes/catppuccin-macchiato.yaml";
      "process-compose/shortcuts.yaml".text =
        # yaml
        ''
          # $XDG_CONFIG_HOME/process-compose/shortcuts.yaml
          shortcuts:
            log_follow: # action name - don't edit
              toggle_description: # optional description for toggle buttons. Will use default if not defined
                false: Follow Off
                true: Follow On
              shortcut: Ctrl-f # shortcut to be used
            log_screen:
              toggle_description:
                false: Half Screen
                true: Full Screen
              shortcut: Ctrl-l
            log_wrap:
              toggle_description:
                false: Wrap Off
                true: Wrap On
              shortcut: Ctrl-w
            process_restart:
              description: Restart # optional description for a button. Will use default if not defined
              shortcut: Ctrl-r
            process_screen:
              toggle_description:
                false: Half Screen
                true: Full Screen
              shortcut: Ctrl-p
            process_start:
              description: Start
              shortcut: Ctrl-s
            process_stop:
              description: Stop
              shortcut: Ctrl-x
            quit:
              description: Quit
              shortcut: q
        '';
    };
  };
}
