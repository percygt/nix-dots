{ inputs, desktop, ... }:
{
  imports = [ inputs.xremap.nixosModules.default ];
  services.xremap = {
    withGnome = desktop == "gnome";
    withWlroots = desktop == "sway";
    config.modmap = [
      {
        name = "Global";
        remap = {
          "CAPSLOCK" = {
            held = [ "CONTROL_L" ];
            alone = [ "ESC" ];
          };
        };
      }
    ];
  };
}
