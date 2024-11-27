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

def create_transient_right_prompt [] {
    let indicator = ([
        (ansi yellow_dimmed)
        (date now | format date '%I:%M:%S <')
    ] | str join)
    $indicator
}
def create_prompt [p] {
    $'(ansi yellow_dimmed)($p)(ansi reset)'
}
# Use nushell functions to define your right and left prompt
# $env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# $env.PROMPT_INDICATOR = {|| create_left_prompt }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| create_prompt "| " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| create_prompt "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| create_prompt ">>> " }

$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = {|| create_prompt "> " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| create_prompt "| " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| create_prompt "> " }
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| create_prompt ">>> " }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = { || create_transient_right_prompt }
# $env.CARAPACE_BRIDGES = 'fish,bash,inshellisense' # optional
source env-extra.nu
