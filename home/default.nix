{
  username,
  stateVersion,
  homeDirectory,
  lib,
  flakeDirectory,
  config,
  pkgs,
  desktop,
  inputs,
  outputs,
  ifPathExists,
  self,
  ...
}: {
  imports =
    [
      ./common
      ./cli
      ./shell
      ./security
      ./users/${username}
    ]
    ++ ifPathExists "${self}/personal/default.nix"
    ++ lib.optionals (desktop == "hyprland")
    [
      inputs.hypridle.homeManagerModules.default
      inputs.hyprlock.homeManagerModules.default
    ];

  programs.home-manager.enable = true;

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.overlays.default
      inputs.hyprland.overlays.default
      inputs.hyprland-contrib.overlays.default
      inputs.hyprlock.overlays.default
    ];

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  news = {
    display = "silent";
    json = lib.mkForce {};
    entries = lib.mkForce [];
  };

  home = {
    inherit
      username
      stateVersion
      homeDirectory
      ;
    activation.report-changes = config.lib.dag.entryAnywhere ''
      if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      fi
    '';
    shellAliases = {
      ll = "eza --group --header --group-directories-first --long --git --all --binary --icons";
      la = "ll -a";
      ls = "eza --group-directories-first --all -1";
      tree = "eza --tree";
      cat = "bat -p";
      dig = "dog";
      grep = "rg";
      mv = "mv -n";
      rm = "rm -i";
      rmrf = "rm -rf";
      rmt = "trash";
      r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
      sc = "systemctl";
      scu = "systemctl --user";
      jc = "journalctl -ex --unit";
      jcu = "journalctl --user -ex --unit";
      curl = "curlie";
      dc = "docker compose";
      hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname --impure";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
      n2ne = "nvim $FLAKE_PATH/packages/node/packages.json";
      n2ni = "node2nix -i $FLAKE_PATH/packages/node/packages.json -e $FLAKE_PATH/packages/node/node-env.nix -o $FLAKE_PATH/packages/node/packages.nix -c $FLAKE_PATH/packages/node/default.nix";
      niso = "nix build .'?submodules=1#'nixosConfigurations.dot_iso.config.system.build.isoImage --impure";
      nd = "nix develop";
      nfu = "nix flake update";
      tldr = "tldr --list | fzf --preview=\"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
      nfui = "nix flake lock --update-input";
    };
    sessionVariables = {
      FLAKE_PATH = flakeDirectory;
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
  };
}
