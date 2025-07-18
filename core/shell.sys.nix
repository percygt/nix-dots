{
  pkgs,
  ...
}:
{
  modules.fileSystem.persist.userData = {
    directories = [
      ".local/share/fish"
      ".local/share/nushell"
      ".local/share/zoxide"
    ];
    files = [ ".config/nushell/history.txt" ];
  };

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
