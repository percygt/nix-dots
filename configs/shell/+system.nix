{
  config,
  ...
}:
let
  g = config._base;
in
{
  modules.fileSystem.persist.userData = {
    directories = [
      ".local/share/fish"
      ".local/share/nushell"
    ];
    files = [ ".config/nushell/history.txt" ];
  };

  programs.fish.enable = true;
  environment = {
    shells = with g.shell; [
      nushell.package
      bash.package
      fish.package
    ];
    systemPackages = with g.shell; [
      nushell.package
      bash.package
      fish.package
    ];
  };
}
