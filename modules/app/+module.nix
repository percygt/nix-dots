{ lib, ... }:
{
  options.modules.app = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
    zen.enable = lib.mkEnableOption "Enable zen";
    brave.enable = lib.mkEnableOption "Enable brave";
    brave-nightly.enable = lib.mkEnableOption "Enable brave-nightly";
    chromium.webapps = {
      ai.enable = lib.mkEnableOption "Enable ai webapp";
      discord.enable = lib.mkEnableOption "Enable discord webappp";
      element.enable = lib.mkEnableOption "Enable element webappp";
      zoom.enable = lib.mkEnableOption "Enable zoom webappp";
    };
  };
}
