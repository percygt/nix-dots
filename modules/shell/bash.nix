{ lib, config, ... }:
{
  options = {
    shell.bash.home.enable = lib.mkOption {
      description = "Enable bash";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.shell.bash.home.enable {
    programs.bash = {
      enable = true;

      profileExtra = ''
        if [[ $(ps --no-header --pid=$PPID --format=comm) != " fish " && -z ''${BASH_EXECUTION_STRING} ]];
        then
            shopt -q login_shell && LOGIN_OPTION="--login" || LOGIN_OPTION=""
            exec fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
