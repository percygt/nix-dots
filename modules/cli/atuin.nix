{ lib, config, ... }:
{
  options.modules.cli.atuin.enable = lib.mkEnableOption "Enable atuin";
  config = lib.mkIf config.modules.cli.atuin.enable {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
