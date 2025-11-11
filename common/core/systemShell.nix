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
      bashInteractive
      fish
    ];
  };
}
