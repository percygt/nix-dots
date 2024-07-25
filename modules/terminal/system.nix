{
  lib,
  username,
  config,
  pkgs,
  ...
}:
{
  options.modules.terminal.enable = lib.mkEnableOption "Enable terminals";
  config = lib.mkIf config.modules.terminal.enable {
    environment.systemPackages = with pkgs; [ foot ];
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.terminal.wezterm.enable = lib.mkDefault true;
      modules.terminal.foot.enable = lib.mkDefault true;
    };
  };
}
