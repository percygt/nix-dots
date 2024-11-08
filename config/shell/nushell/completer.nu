let fish_completer = {|spans: list<string>|
  let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans
  })
  fish -c $'complete "--do-complete=($spans | str join " ")"'
  | $"value(char tab)description(char newline)" + $in
  | from tsv --flexible --no-infer
}

$env.config = ($env.config?
| default {}
| merge { completions: { external: { completer: $fish_completer } } })

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let prev_completer = $env.config?.completions?.external?.completer? | default echo
let next_completer = {|spans: list<string>|
  let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans
  })
  if $spans.0 in [__zoxide_z __zoxide_zi] {
    $spans | skip 1 | zoxide query -l ...$in | lines | where $it != $env.PWD
  } else if $spans.0 == zoxide and $spans.1? == remove {
    $spans | get 2 | zoxide query -l $in | lines | where $it != $env.PWD
  } else {
    do $carapace_completer $spans
  }
}
$env.config = ($env.config?
| default {}
| merge { completions: { external: { completer: $next_completer } } })
