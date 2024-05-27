{
  lib,
  config,
  ...
}: {
  options = {
    shell.bash.enable =
      lib.mkEnableOption "Enable bash";
  };

  config = lib.mkIf config.shell.bash.enable {
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
