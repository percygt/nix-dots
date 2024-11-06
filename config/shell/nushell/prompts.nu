
def create_transient_right_prompt [] {
    let indicator = ([
        (ansi reset)
        (ansi yellow_dimmed)
        (date now | format date '%I:%M:%S')
    ] | str join)
    $indicator
}
export-env {
  # Use nushell functions to define your right and left prompt
  # $env.PROMPT_COMMAND = {|| create_left_prompt }
  # $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

  # $env.PROMPT_INDICATOR = {|| create_left_prompt }
  $env.PROMPT_INDICATOR_VI_NORMAL = {|| "󰰔 " }
  $env.PROMPT_INDICATOR_VI_INSERT = {|| " " }
  $env.PROMPT_MULTILINE_INDICATOR = {|| " " }

  $env.TRANSIENT_PROMPT_COMMAND = {|| "" }
  $env.TRANSIENT_PROMPT_INDICATOR = {|| " " }
  $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "󰰔 " }
  $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| " " }
  $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| " " }
  $env.TRANSIENT_PROMPT_COMMAND_RIGHT = { || create_transient_right_prompt }
}
