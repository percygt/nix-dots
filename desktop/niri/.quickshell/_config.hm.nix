{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  g = config._global;
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
      lm_sensors
      aubio
      grim
      swappy
      libqalculate
      inotify-tools
      bluez
      bash
      file
      fira-code
      cava
      material-icons
      cliphist
      bluez
      brightnessctl
      coreutils
      ddcutil
      findutils
      libnotify
      matugen
      networkmanager
      wlsunset
      wl-clipboard
      gpu-screen-recorder
    ]
    ++ [
      (inputs.quickshell.packages.${pkgs.system}.default.override {
        withX11 = false;
        withI3 = false;
      })
    ];
}
