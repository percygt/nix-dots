let
  wsToKey = ws: builtins.substring 0 1 ws;
in {
  mkWorkspaceKeys = mod: workspaces:
    builtins.listToAttrs ((builtins.map (ws: {
          name = mod + "+" + wsToKey ws;
          value = "workspace ${ws}";
        })
        workspaces)
      ++ (builtins.map (ws: {
          name = mod + "+Shift+" + wsToKey ws;
          value = "move container to workspace ${ws}";
        })
        workspaces));

  mkDirectionKeys = mod: keypairs:
    builtins.listToAttrs (
      (builtins.map (v: {
        name = mod + "+" + keypairs.${v};
        value = "focus ${v}";
      }) (builtins.attrNames keypairs))
      ++ (builtins.map (v: {
        name = mod + "+Shift+" + keypairs.${v};
        value = "move ${v}";
      }) (builtins.attrNames keypairs))
      ++ (builtins.map (v: {
        name = mod + "+Ctrl+" + keypairs.${v};
        value = "move workspace output ${v}";
      }) (builtins.attrNames keypairs))
    );
}
