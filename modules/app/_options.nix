{ lib, ... }:
{
  options.modules.app = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
    zen.enable = lib.mkEnableOption "Enable zen";
    brave.enable = lib.mkEnableOption "Enable brave";
    helium.enable = lib.mkEnableOption "Enable helium";
    brave-nightly.enable = lib.mkEnableOption "Enable brave-nightly";
    quickemu.enable = lib.mkEnableOption "Enable quickemu";
    flatpak.enable = lib.mkEnableOption "Enable flatpak";
    chromium.enable = lib.mkEnableOption "Enable chromium";
    chromium-webapps = {
      chatgpt.enable = lib.mkEnableOption "Enable ai webapp";
      discord.enable = lib.mkEnableOption "Enable discord webappp";
      element.enable = lib.mkEnableOption "Enable element webappp";
      zoom.enable = lib.mkEnableOption "Enable zoom webappp";
    };
  };
}
