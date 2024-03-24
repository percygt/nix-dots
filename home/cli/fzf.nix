{
  lib,
  config,
  ...
}: {
  options = {
    cli.fzf.enable =
      lib.mkEnableOption "Enable fzf";
  };

  config = lib.mkIf config.cli.fzf.enable {
    programs = {
      fzf = {
        enable = true;
        enableFishIntegration = false;
      };
    };
  };
}
