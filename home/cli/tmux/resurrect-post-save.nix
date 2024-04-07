{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.cli.tmux.enable {
    home.packages = with pkgs; [
      (
        writeShellScriptBin
        "resurrect-post-save"
        /*
        bash
        */
        ''
          sed -ie "s| --cmd .*-vim-pack-dir||g" $1
          sed -ie "s|nvim --cmd.*ruby.|nvim|g" $1
          sed -ie "s|/etc/profiles/per-user/$USER/bin/||g" $1
          sed -ie "s|/home/$USER/.nix-profile/bin/||g" $1
          sed -i 's|fish	:\[fish\] <defunct>|fish	:|g' $1
          sed -i ':a;N;$!ba;s|\[fish\] <defunct>\n||g' $1
          sed -i "s|/run/current-system/sw/bin/||g" $1
          sed -i "s| $HOME| ~|g" $1
          sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" $1
        ''
      )
    ];
  };
}
