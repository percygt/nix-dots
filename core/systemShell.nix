{
  pkgs,
  ...
}:
{
  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [
      nushell
      bash
      fish
    ];
    systemPackages = with pkgs; [
      nushell
      bash
      fish
    ];
  };
}
