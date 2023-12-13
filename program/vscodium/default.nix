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
  home.packages = with pkgs;
  with nodePackages_latest; [
    #linter/formatter/langserver
    eslint
    black
    ruff
    isort
    pyupgrade
    shellcheck
    sumneko-lua-language-server
    stylua

    #lang
    nodejs
    go
  ];
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
