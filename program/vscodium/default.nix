{
  pkgs,
  config,
  lib,
  ...
}: let
  extension-list = import ./extensions.nix {
    inherit pkgs;
  };
  hmVsCode = "${config.xdg.configHome}/home-manager/common/vscode/settings.json";
  userVsCode = "${config.xdg.configHome}/VSCodium/User/settings.json";
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    inherit (extension-list) extensions;
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
