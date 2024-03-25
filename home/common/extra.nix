{
  lib,
  is_generic_linux,
  pkgs,
  ui,
  inputs,
  config,
  ...
}:
lib.optionalAttrs is_generic_linux {
  imports = [
    inputs.xremap.homeManagerModules.default
  ];
  # This configures the service to only run for a specific user
  services.xremap = {
    withGnome = true;
  };
  # Modmap for single key rebinds
  services.xremap.config.modmap = [
    {
      name = "Global";
      remap = {
        "CAPSLOCK" = {
          held = ["CONTROL_L"];
          alone = ["ESC"];
          alone_timeout_millis = 150;
        };
      };
    }
  ];
  home = {
    activation.setupXremap = config.lib.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/systemctl start --user xremap
    '';
  };

  fonts.fontconfig.enable = true;
  home.packages = ui.fonts.packages pkgs;
  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    joypixels.acceptLicense = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}
