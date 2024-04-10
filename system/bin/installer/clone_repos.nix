{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "clone_repos"
      ''
        set -euo pipefail
        sec_dir="$HOME/sikreto";

        if [ ! -d "$sec_dir/.git" ]; then
          git clone git@gitlab.com:percygt/sikreto.git "$sec_dir"
        fi
      ''
    )
  ];
}
