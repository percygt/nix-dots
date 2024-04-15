{pkgs, ...}: {
  services.kanshi = {
    enable = true;
    profiles = {
      solo.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
        }
      ];
      with-monitor = {
        exec = ["${pkgs.sway}/bin/swaymsg workspace 1, move workspace to eDP-1"];
        outputs = [
          {
            criteria = "Lenovo Group Limited D24-20 U760KTZC";
            mode = "1920x1080@60Hz";
            position = "0,1080";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            position = "0,0";
            status = "enable";
          }
        ];
      };
    };
  }; # END kanshi
}
