let fish_completer = {|spans: list<string>|
  fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

$env.config = ($env.config?
| default {}
| merge { completions: { external: { completer: $fish_completer } } })

let prev_completer = $env.config?.completions?.external?.completer? | default echo

let carapace_completer = {|spans: list<string>|
  let completion = carapace $spans.0 nushell ...$spans
    if $completion != "" {
      let parsed_completion = $completion | from json
      if ($parsed_completion | where value == $"($spans | last)ERR" | is-empty) {
        return $parsed_completion
      }
    }
    do $prev_completer $spans
}

let next_completer = {|spans: list<string>|
  let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion
  # overwrite
  let spans = if $expanded_alias != null {
    $spans
      | skip 1
      | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }
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
