{lib}: let
  wsToKey = ws: builtins.substring 0 1 ws;
in rec {
  package = pkgs:
    pkgs.swayfx.override {
      inherit (pkgs) swayfx-unwrapped;
    };

  mkWorkspaceKeys = mod: workspaces:
    builtins.listToAttrs ((map (ws: {
          name = mod + "+" + wsToKey ws;
          value = "workspace ${ws}";
        })
        workspaces)
      ++ (map (ws: {
          name = mod + "+Shift+" + wsToKey ws;
          value = "move container to workspace ${ws}";
        })
        workspaces));

  mkDirectionKeys = mod: keypairs:
    builtins.listToAttrs (
      (map (v: {
        name = mod + "+" + keypairs.${v};
        value = "focus ${v}";
      }) (builtins.attrNames keypairs))
      ++ (map (v: {
        name = mod + "+Shift+" + keypairs.${v};
        value = "move ${v}";
      }) (builtins.attrNames keypairs))
      ++ (map (v: {
        name = mod + "+Ctrl+" + keypairs.${v};
        value = "move workspace output ${v}";
      }) (builtins.attrNames keypairs))
    );

  mapApps = {
    command,
    crit_name,
    crits,
  }:
    map (
      crit: {
        inherit command;
        criteria = {
          ${crit_name} = crit;
        };
      }
    )
    crits;
  mkAppsFloat = {
    app_ids ? null,
    classes ? null,
    titles ? null,
    w ? 80,
    h ? 80,
    command ? ''floating enable, resize set width ${toString w} ppt height ${toString h} ppt'',
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
