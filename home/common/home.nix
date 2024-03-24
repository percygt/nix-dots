{
  lib,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    inherit
      username
      stateVersion
      homeDirectory
      ;
  };

  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  news = {
    display = "silent";
    json = lib.mkForce {};
    entries = lib.mkForce [];
  };
}
