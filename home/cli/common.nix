{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    cli.common.enable =
      lib.mkEnableOption "Enable common cli tools";
  };

  config = lib.mkIf config.cli.common.enable {
    home.packages = with pkgs; [
      git
      du-dust
      dua
      duf
      yq-go # portable command-line YAML, JSON and XML processor
      fd
      ripgrep
      unrar
      curlie
      p7zip
      jq
      aria2
      gping
      xcp
      dogdns

      age
      sops
      git-crypt
    ];
  };
}
