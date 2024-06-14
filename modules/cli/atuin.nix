{
  lib,
  config,
  ...
}: {
  options.cli.atuin.home.enable = lib.mkEnableOption "Enable atuin";
  config = lib.mkIf config.cli.atuin.home.enable {
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
