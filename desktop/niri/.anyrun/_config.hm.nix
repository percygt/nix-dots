{
  modulesPath,
  config,
  pkgs,
  inputs,
  ...
}:
let
  g = config._global;
  moduleAnyrun = "${g.flakeDirectory}/desktop/niri/anyrun";
in
{
  disabledModules = [ "${modulesPath}/programs/anyrun.nix" ];
  imports = [ inputs.anyrun.homeManagerModules.anyrun ];
  programs.anyrun = {
    enable = true;
    package = pkgs.anyrunPackages.anyrun-with-all-plugins;
    # The package should come from the same flake as all the plugins to avoid breakage.
    config = {
      # The horizontal position.
      # when using `fraction`, it sets a fraction of the width or height of the screen
      x.fraction = 0.5; # at the middle of the screen
      # The vertical position.
      y.fraction = 0.05; # at the top of the screen
      # The width of the runner.
      width.fraction = 0.3; # 30% of the screen

      hidePluginInfo = true;
      ignoreExclusiveZones = true;
      plugins = [
        "niri-focus"
        "applications"
        "nix-run"
        "symbols"
        "kidex"
        "rink"
        "translate"
      ];
    };
  };
  xdg.configFile =
    let
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "anyrun/style.css".source = symlink "${moduleAnyrun}/style.css";
      "anyrun/applications.ron".source = symlink "${moduleAnyrun}/applications.ron";
    };
}
