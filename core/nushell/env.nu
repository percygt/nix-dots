$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.NU_LIB_DIRS = [
    ($nu.default-config-dir)
    ($nu.default-config-dir | path join "modules")
    ($nu.default-config-dir | path join "scripts")
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

def create_left_prompt [] {
  (
   starship prompt
      --cmd-duration $env.CMD_DURATION_MS
      $"--status=($env.LAST_EXIT_CODE)"
      --terminal-width "189"
  )
}

def create_transient_right_prompt [] {
    let indicator = ([
        (ansi yellow_dimmed)
        (date now | format date '%I:%M:%S <')
    ] | str join)
    $indicator
}
def create_prompt_symbol [p] {
    $'(ansi yellow_dimmed)($p)(ansi reset)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# $env.PROMPT_INDICATOR = {|| create_left_prompt }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| create_prompt_symbol "| " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| create_prompt_symbol "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| create_prompt_symbol ">>> " }

$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = {|| create_prompt_symbol "> " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| create_prompt_symbol "| " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| create_prompt_symbol "> " }
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| create_prompt_symbol ">>> " }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = { || create_transient_right_prompt }
source env-extra.nu
