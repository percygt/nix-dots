{inputs, ...}: {
  imports = [inputs.xremap.nixosModules.default];
  services.xremap.withWlroots = true;
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
}
