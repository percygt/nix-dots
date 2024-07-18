{
  lib,
  username,
  config,
  pkgs,
  ...
}:
{
  options.terminal.system.enable = lib.mkEnableOption "Enable terminals";
  config = lib.mkIf config.terminal.system.enable {
    environment.systemPackages = with pkgs; [ foot ];
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      terminal.wezterm.home.enable = lib.mkDefault true;
      terminal.foot.home.enable = lib.mkDefault true;
    };
  };
}
