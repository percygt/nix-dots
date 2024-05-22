{
  config,
  lib,
  ...
}: {
  options = {
    cli.ncmpcpp.enable =
      lib.mkEnableOption "Enables ncmpcpp";
  };
  config = lib.mkIf config.cli.ncmpcpp.enable {
    programs.ncmpcpp = {
      enable = true;
      settings = {
        ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
        lyrics_directory = "${config.xdg.dataHome}/ncmpcpp/lyrics";
      };
    };

    services.mpd = {
      enable = true;
      musicDirectory = config.xdg.userDirs.music;
      network.startWhenNeeded = true;

      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire"
        }
      '';
    };
  };
}
