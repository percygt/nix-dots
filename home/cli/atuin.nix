{
  lib,
  config,
  ...
}: {
  options = {
    cli.atuin.enable =
      lib.mkEnableOption "Enable atuin";
  };

  config = lib.mkIf config.cli.atuin.enable {
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
