{
  lib,
  config,
  pkgs,
  libx,
  ...
}:
let
  g = config._general;
  inherit (libx) enableDefault inheritModule;
  inheritTerminal =
    module:
    inheritModule {
      inherit module config;
      name = "terminal";
    };
in
{
  options.modules.terminal = {
    foot.enable = enableDefault "foot";
    wezterm.enable = enableDefault "wezterm";
    rio.enable = enableDefault "rio";
  };
  config = lib.mkMerge [
    {
      home-manager.users.${g.username} = import ./home.nix;
      environment.systemPackages = with pkgs; [ foot ];
    }
    (inheritTerminal "foot")
    (inheritTerminal "wezterm")
    (inheritTerminal "rio")
  ];
}
