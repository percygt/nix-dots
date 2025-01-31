{
  xdg.dataFile = {
    "navi/cheats/dev.cheat".source = ./dev.cheat;
  };
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = true;
      };
    };
  };
  programs.navi = {
    enable = false;
    settings = {
      style = {
        tag = {
          width_percentage = 15;
        };
        comment = {
          width_percentage = 45;
        };
        snippet = {
          width_percentage = 40;
        };
      };
      client = {
        tealdeer = true;
      };
    };
  };
}
