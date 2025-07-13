let fish_completer = {|spans: list<string>|
  fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let carapace_completer = {|spans: list<string>|
  let completion = carapace $spans.0 nushell ...$spans
    if $completion != "" {
      let parsed_completion = $completion | from json
      if ($parsed_completion | where value == $"($spans | last)ERR" | is-empty) {
        return $parsed_completion
      }
    }
}

let external_completer = {|spans: list<string>|
  let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

  let spans = if $expanded_alias != null {
    $spans
      | skip 1
      | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  match $spans.0 {
      # carapace completions are incorrect for nu
      nu => $fish_completer
      __zoxide_z | __zoxide_zi => $zoxide_completer
      _ => $carapace_completer
  } | do $in $spans
}
$env.config = ($env.config?
  | default {}
  | merge { completions: { external: { completer: $external_completer } } })
