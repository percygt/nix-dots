{
  programs = {
    carapace = {
      enable = true;
      enableFishIntegration = false;
      # Use custom integration
      enableNushellIntegration = false;
    };

    # # https://www.nushell.sh/cookbook/external_completers.html
    # nushell.extraConfig =
    #   #nu
    #   ''
    #     let prev_completer = $env.config?.completions?.external?.completer? | default echo
    #     let next_completer = {|spans: list<string>|
    #       let completion = carapace $spans.0 nushell ...$spans
    #       if $completion != "" {
    #         let parsed_completion = $completion | from json
    #         if ($parsed_completion | where value == $"($spans | last)ERR" | is-empty) {
    #           return $parsed_completion
    #         }
    #       }
    #       do $prev_completer $spans
    #     }
    #     $env.config = ($env.config?
    #     | default {}
    #     | merge { completions: { external: { completer: $next_completer } } })
    #   '';
  };
}
