{
  username,
  stateVersion,
  homeDirectory,
  lib,
  flakeDirectory,
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;
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
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      FLAKE_PATH = flakeDirectory;
    };
  };
}
