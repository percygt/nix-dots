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
      "process-compose/shortcuts.yaml".text =
        # yaml
        ''
          # $XDG_CONFIG_HOME/process-compose/shortcuts.yaml
          shortcuts:
            log_follow: # action name - don't edit
              toggle_description: # optional description for toggle buttons. Will use default if not defined
                false: Follow Off
                true: Follow On
              shortcut: F5 # shortcut to be used
            log_screen:
              toggle_description:
                false: Half Screen
                true: Full Screen
              shortcut: F4
            log_wrap:
              toggle_description:
                false: Wrap Off
                true: Wrap On
              shortcut: F6
            process_restart:
              description: Restart # optional description for a button. Will use default if not defined
              shortcut: Ctrl-R
            process_screen:
              toggle_description:
                false: Half Screen
                true: Full Screen
              shortcut: F8
            process_start:
              description: Start
              shortcut: F7
            process_stop:
              description: Stop
              shortcut: F9
            quit:
              description: Quit
              shortcut: F10
        '';
    };
  };
}
