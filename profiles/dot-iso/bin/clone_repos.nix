{
  pkgs,
  flakeDirectory,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "clone_repos"
      ''
        set -euo pipefail
        dots_dir=${flakeDirectory};
        sec_dir="$HOME/sikreto";

        if [ ! -d "$dots_dir/.git" ]; then
          git clone git@gitlab.com:percygt/nix-dots.git "$dots_dir"
        fi
        sleep 1
        if [ ! -d "$sec_dir/.git" ]; then
          git clone git@gitlab.com:percygt/sikreto.git "$sec_dir"
        fi
      ''
    )
  ];
}
