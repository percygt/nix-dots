{ lib, ... }:
{
  home.shellAliases.zz = "z -";
  programs = {
    zoxide.enable = true;
    nushell = {
      shellAliases.zz = "z -";
      # After carapace sets up completions
      # https://www.nushell.sh/cookbook/external_completers.html
      extraConfig =
        lib.mkAfter
          #nu
          ''
            let prev_completer = $env.config?.completions?.external?.completer? | default echo
            let next_completer = {|spans|
              if $spans.0 in [__zoxide_z __zoxide_zi] {
                $spans | skip 1 | zoxide query -l ...$in | lines | where $it != $env.PWD
              } else if $spans.0 == zoxide and $spans.1? == remove {
                $spans | get 2 | zoxide query -l $in | lines | where $it != $env.PWD
              } else {
                do $prev_completer $spans
              }
            }
            $env.config = ($env.config?
            | default {}
            | merge { completions: { external: { completer: $next_completer } } })
          '';
    };
  };
}
