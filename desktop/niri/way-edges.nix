{ inputs, ... }:
{
  imports = [ inputs.way-edges.homeManagerModules.default ];
  programs.way-edges = {
    enable = true;
    settings = {
      groups = [
        {
          name = "sway";
          widgets = [
            {
              edge = "bottom";
              position = "right";
              layer = "overlay";
              monitor = "HDMI-A-1";
              widget = {
                type = "workspace";
                thickness = 25;
                length = "25%";
                hover_color = "#ffffff22";
                active_increase = 0.2;
                active_color = "#6B8EF0";
                deactive_color = "#000";
              };
            }
          ];
        }
      ];
    };
  };
}
