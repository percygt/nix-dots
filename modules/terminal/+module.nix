{ lib, pkgs, ... }:
{
  options.modules.terminal = {
    foot = {
      enable = lib.mkEnableOption "Enable foot";
      package = lib.mkOption {
        description = "Foot terminal package";
        type = lib.types.package;
        default = pkgs.foot;
      };
    };
    tilix = {
      enable = lib.mkEnableOption "Enable tilix";
      package = lib.mkOption {
        description = "Tilix terminal package";
        type = lib.types.package;
        default = pkgs.tilix;
      };
    };
    xfce4-terminal = {
      enable = lib.mkEnableOption "Enable xfce4-terminal";
      package = lib.mkOption {
        description = "Xfce4-terminal package";
        type = lib.types.package;
        default = pkgs.xfce.xfce4-terminal;
      };
    };
    wezterm = {
      enable = lib.mkEnableOption "Enable wezterm";
      package = lib.mkOption {
        description = "Wwezterm terminal package";
        type = lib.types.package;
        default = pkgs.wezterm;
      };
    };
  };
}
