{
  pkgs,
  config,
  lib,
  inputs,
  flakeDirectory,
  homeDirectory,
  ...
}:
let
  moduleVscode = "${flakeDirectory}/modules/editor/vscode/config";
in
{
  imports = [ inputs.vscode-server.homeModules.default ];
  options.modules.editor.vscode.enable = lib.mkEnableOption "Enable vscode home";
  config = lib.mkIf config.modules.editor.neovim.enable {
    home.shellAliases.code = "codium";
    services.vscode-server = {
      enable = true;
      enableFHS = false;
      installPath = "${homeDirectory}/.vscode-oss";
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhsWithPackages (
        ps: with ps; [
          rustup
          zlib
        ]
      );
      enableUpdateCheck = true;
      mutableExtensionsDir = false;
      enableExtensionUpdateCheck = true;
      # extensions = inputs.nix-stash.vscodeExtensions."${pkgs.system}";
      # userSettings = builtins.fromJSON (builtins.readFile ./config/settings.json);
      # keybindings = builtins.fromJSON (builtins.readFile ./config/keybindings.json);
    };
    xdg = {
      configFile = {
        "VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleVscode}/settings.json";
        "VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleVscode}/keybindings.json";
      };
    };
  };
}
