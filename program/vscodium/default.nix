{
  pkgs,
  inputs,
  ...
}: let
  extension-list = import ./extensions.nix {
    inherit pkgs;
    inherit inputs;
  };
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    extensions = extension-list.extensions;
    userSettings = builtins.fromJSON (builtins.readFile ../../common/vscode/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ../../common/vscode/keybindings.json);
  };
}
