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
  ui,
  ...
}: {
  imports =
    [
      ./common
      ./cli
      ./shell
      inputs.sops-nix.homeManagerModules.sops
    ]
    ++ lib.optionals (builtins.pathExists ../personal/default.nix)
    [
      ../personal
    ]
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
      ll = "ls -l";
      la = "ls -la";
      ls = "eza --sort type --icons -F -H --group-directories-first -1";
      cat = "bat -p";
      rm = "rm -i";
      mv = "mv -n";
      r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
      sc = "systemctl";
      scu = "systemctl --user";
      jc = "journalctl -ex --unit";
      jcu = "journalctl --user -ex --unit";
      code = "codium";
      v = "nvim";
      y = "yazi";
      dc = "docker compose";
      hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
    };
    sessionVariables = {
      FLAKE_PATH = flakeDirectory;
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
  };
}
