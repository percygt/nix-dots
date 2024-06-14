{
  lib,
  config,
  ...
}: {
  options = {
    cli.atuin.enable =
      lib.mkEnableOption "Enable atuin";
  };

  config = lib.mkIf config.cli.atuin.home.enable {
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
