{
  lib,
  config,
  ...
}: {
  options = {
    cli.eza.enable =
      lib.mkEnableOption "Enables eza";
  };
  config = lib.mkIf config.cli.eza.enable {
    programs = {
      eza = {
        enable = true;
        icons = true;
      };
    };
  };
}
