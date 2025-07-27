{ lib, pkgs, ... }:
{
  options.modules.terminal = {
    foot = {
      enable = lib.mkEnableOption "Enable foot";
      cmd = lib.mkOption {
        description = "Foot terminal command";
        type = lib.types.str;
        default = "footclient";
      };
      package = lib.mkOption {
        description = "Foot terminal package";
        type = lib.types.package;
        default = pkgs.foot;
      };
    };
    tilix = {
      enable = lib.mkEnableOption "Enable tilix";
      cmd = lib.mkOption {
        description = "Tilix terminal command";
        type = lib.types.str;
        default = "tilix";
      };
      package = lib.mkOption {
        description = "Tilix terminal package";
        type = lib.types.package;
        default = pkgs.tilix;
      };
    };
    xfce4-terminal = {
      enable = lib.mkEnableOption "Enable xfce4-terminal";
      cmd = lib.mkOption {
        description = "Xfce4-terminal terminal command";
        type = lib.types.str;
        default = "xfce4-terminal";
      };
      package = lib.mkOption {
        description = "Xfce4-terminal package";
        type = lib.types.package;
        default = pkgs.xfce.xfce4-terminal;
      };
    };
    wezterm = {
      enable = lib.mkEnableOption "Enable wezterm";
      cmd = lib.mkOption {
        description = "Wezterm terminal command";
        type = lib.types.str;
        default = "wezterm";
      };
      package = lib.mkOption {
        description = "Wezterm terminal package";
        type = lib.types.package;
        default = pkgs.wezterm;
      };
    };
  };
}
