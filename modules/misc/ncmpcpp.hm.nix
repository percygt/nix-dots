{ config, lib, ... }:
{
  config = lib.mkIf config.modules.misc.ncmpcpp.enable {
    programs.ncmpcpp = {
      enable = true;
      settings = {
        ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
        lyrics_directory = "${config.xdg.dataHome}/ncmpcpp/lyrics";
      };
    };
    #
    #   services.mpd = {
    #     enable = true;
    #     musicDirectory = config.xdg.userDirs.music;
    #     network.startWhenNeeded = true;
    #
    #     extraConfig = ''
    #       audio_output {
    #         type "pipewire"
    #         name "Pipewire"
    #       }
    #     '';
    #   };
  };
}
