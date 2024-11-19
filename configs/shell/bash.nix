{ config, ... }:
{
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [[ $(ps --no-header --pid=$PPID --format=comm) != " fish " && -z ''${BASH_EXECUTION_STRING} ]];
      then
          shopt -q login_shell && LOGIN_OPTION="--login" || LOGIN_OPTION=""
          exec fish $LOGIN_OPTION
      fi
    '';
    bashrcExtra = ''
      export STARSHIP_CONFIG="${config.xdg.configHome}/starship.toml"
    '';
    shellAliases = {
      ll = "eza --group --header --group-directories-first --long --git --all --binary --icons";
      la = "ll -a";
      l = "eza --group-directories-first --all -1";
      date-sortable = "date +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with local timezone
      date-sortable-utc = "date -u +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with UTC timezone
      tmp = "pushd $(mktemp -d)";
    };
  };
}
