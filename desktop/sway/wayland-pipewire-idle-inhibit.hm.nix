{ pkgs, inputs, ... }:
{
  imports = [ inputs.wayland-pipewire-idle-inhibit.homeModules.default ];
  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    package = pkgs.wayland-pipewire-idle-inhibit;
    systemdTarget = "sway-session.target";
    settings = {
      verbosity = "INFO";
      idle_inhibitor = "wayland";
      media_minimum_duration = 30;
      sink_whitelist = [ ];
      node_blacklist = [ ];
    };
  };
}
