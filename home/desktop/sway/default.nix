{
  pkgs,
  libx,
  config,
  lib,
  isGeneric,
  ...
}: {
  imports = [
    ./waybar
    ./mako.nix
    ./services.nix
    ./i3-quickterm.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swappy.nix
    # ./wpapered.nix
    ./tofi.nix
  ];
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
  nix.settings.substituters = ["https://nixpkgs-wayland.cachix.org"];
  nix.settings.trusted-public-keys = ["nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="];
  services.caffeine.enable = true;
  xsession.importedVariables = ["PATH"];
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx.overrideAttrs (_: {passthru.providedSessions = ["sway"];});
    swaynag.enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    inherit (import ./extraConfig.nix) extraConfig;
    inherit (import ./extraSessionCommands.nix) extraSessionCommands;
    inherit (import ./config.nix {inherit pkgs config lib libx isGeneric;}) config;
    wrapperFeatures.gtk = true;
  };
}
