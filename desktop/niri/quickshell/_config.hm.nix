{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  g = config._base;
  moduleQuickshell = "${g.flakeDirectory}/desktop/niri/quickshell/quickshell";
in
{
  xdg.configFile."quickshell".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink moduleQuickshell
  );
  home.packages =
    with pkgs;
    [
      brightnessctl
      app2unit
      networkmanager
      lm_sensors
      aubio
      grim
      swappy
      libqalculate
      inotify-tools
      bluez
      bash
      coreutils
      findutils
      file
      fira-code
      cava
      material-icons
      wl-clipboard
      cliphist
      ddcutil
      matugen
    ]
    ++ [
      (inputs.quickshell.packages.${pkgs.system}.default.override {
        withX11 = false;
        withI3 = false;
      })
    ];
}
