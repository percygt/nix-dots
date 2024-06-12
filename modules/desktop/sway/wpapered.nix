{
  pkgs,
  config,
  ...
}: let
  wpaperd-config = {
    default = {
      path = "${config.xdg.dataHome}/backgrounds";
    };
  };

  wpaperd-config-dir = pkgs.runCommand "wpaperd-config" {} ''
    mkdir -p $out/wpaperd
    cp ${(pkgs.formats.toml {}).generate "wallpaper.toml" wpaperd-config} $out/wpaperd/wallpaper.toml
  '';
in {
  systemd.user.services.wpaperd = {
    Unit = {
      Description = "Wallpaper daemon";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd --no-daemon";
      Environment = "XDG_CONFIG_HOME=${wpaperd-config-dir}";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
