{ lib, config, ... }:
{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = false;
      nix-direnv.enable = true;
      config = {
        global = {
          strict_env = true;
          warn_timeout = "1m";
        };
      };
    };
  };
  programs.nushell.extraConfig =
    lib.mkAfter
      # nu
      ''
        $env.config = ($env.config? | default {})
        $env.config.hooks = ($env.config.hooks? | default {})
        $env.config.hooks.pre_prompt = (
            $env.config.hooks.pre_prompt?
            | default []
            | append {||
                ${lib.getExe config.programs.direnv.package} export json
                | from json --strict
                | default {}
                | items {|key, value|
                    let value = do (
                        {
                          "PATH": {
                            from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                            to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                          }
                        }
                        | merge ($env.ENV_CONVERSIONS? | default {})
                        | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                        | if ($in | is-empty) { {|x| $x} } else { $in }
                    ) $value
                    return [ $key $value ]
                }
                | into record
                | load-env
            }
        )
      '';
  # Suppress direnv's verbose output
  # https://github.com/direnv/direnv/issues/68#issuecomment-42525172
  # home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
