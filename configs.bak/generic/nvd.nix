{ pkgs, config, ... }:
{
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    fi
  '';
}
