{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  hmVsCode = "${config.xdg.configHome}/home-manager/common/vscode/settings.json";
  userVsCode = "${config.xdg.configHome}/VSCodium/User/settings.json";
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    extensions = inputs.nix-stash.lib.vscodeExtensions {inherit (pkgs) system;};
    userSettings = builtins.fromJSON (builtins.readFile ../../common/vscode/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ../../common/vscode/keybindings.json);
  };
  home = {
    activation = {
      removeExistingVSCodeSettings = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        [ -e ${userVsCode} ] && rm "${userVsCode}"
      '';

      overwriteVSCodeSymlink = lib.hm.dag.entryAfter ["linkGeneration"] ''
        rm "${userVsCode}"
        ln -s "${hmVsCode}" "${userVsCode}"
      '';
    };
  };
}
