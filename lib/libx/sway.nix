{ lib }:
rec {
  mapApps =
    {
      command,
      crit_name,
      crits,
    }:
    map (crit: {
      inherit command;
      criteria = {
        ${crit_name} = crit;
      };
    }) crits;
  mkAppsFloat =
    {
      app_ids ? null,
      classes ? null,
      titles ? null,
      w ? 80,
      h ? 80,
      command ? "floating enable, resize set width ${toString w} ppt height ${toString h} ppt",
    }:
    lib.optionals (app_ids != null) (mapApps {
      inherit command;
      crit_name = "app_id";
      crits = app_ids;
    })
    ++ lib.optionals (classes != null) (mapApps {
      inherit command;
      crit_name = "class";
      crits = classes;
    })
    ++ lib.optionals (titles != null) (mapApps {
      inherit command;
      crit_name = "title";
      crits = titles;
    });
}
