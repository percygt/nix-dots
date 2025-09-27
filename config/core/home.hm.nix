{
  lib,
  username,
  stateVersion,
  homeDirectory,
  config,
  ...
}:
let
  g = config._global;
in
{
  programs.home-manager.enable = true;
  home = {
    sessionVariables = g.system.envVars;
    shellAliases = {
      mv = "mv -n";
      rm = "rm -i";
      rmrf = "rm -rf";
      rmt = "trash";
      r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
      sc = "systemctl";
      scu = "systemctl --user";
      jc = "journalctl -exf --unit";
      jcu = "journalctl --user -exf --unit";
      curl = "curlie";
      dc = "docker compose";
      ts = "tailscale";
      tssh = "tailscale ssh";
      tst = "tailscale status";
      tsu = "sudo tailscale up --ssh --operator=$USER";
      tsd = "tailscale down";
      noms = "nom shell";
      nomd = "nom develop";
      nix-repl-flake = "nix repl --expr \"(builtins.getFlake (toString ${g.flakeDirectory}))\"";
      lsblk = "lsblk -o NAME,SIZE,TYPE,FSTYPE,FSVER,MOUNTPOINTS";
      cleanup-results = "bash -c \"find . -type l -name 'result*' -exec echo 'unlinking {}' ; -exec unlink {}\"";
      gcstore = "bash -c \"nix-env --delete-generations +3 ; nix store gc --verbose ; nix store optimise --verbose\"";
    };
  };

  systemd.user.startServices = "sd-switch";

  home = {
    inherit username stateVersion homeDirectory;
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  news = {
    display = "silent";
    json = lib.mkForce { };
    entries = lib.mkForce [ ];
  };
}
