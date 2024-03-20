{
  pkgs,
  config,
  lib,
  inputs,
  flakeDirectory,
  ...
}: let
  HM_VSCODE = "${flakeDirectory}/home/editor/vscode/config";
  USER_VSCODE = "${config.xdg.configHome}/VSCodium/User/settings.json";
in {
  home.shellAliases.code = "codium";
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    extensions = inputs.nix-stash.lib.vscodeExtensions {inherit (pkgs) system;};
    userSettings = builtins.fromJSON (builtins.readFile ./config/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ./config/keybindings.json);
  };
  home = {
    activation = {
      removeExistingVSCodeSettings = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        [ -e ${USER_VSCODE} ] && rm "${USER_VSCODE}"
      '';

      overwriteVSCodeSymlink = lib.hm.dag.entryAfter ["linkGeneration"] ''
        rm "${USER_VSCODE}"
        ln -s "${HM_VSCODE}" "${USER_VSCODE}"
      '';
    };
  };
}
