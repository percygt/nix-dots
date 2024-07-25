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
  HM_VSCODE = "${flakeDirectory}/home/editor/vscode/config";
  USER_VSCODE = "${config.xdg.configHome}/VSCodium/User/settings.json";
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
      userSettings = builtins.fromJSON (builtins.readFile ./config/settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./config/keybindings.json);
    };
    home = {
      activation = {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          [ -e ${USER_VSCODE} ] && rm "${USER_VSCODE}"
        '';

        overwriteVSCodeSymlink = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          rm "${USER_VSCODE}"
          ln -s "${HM_VSCODE}" "${USER_VSCODE}"
        '';
      };
    };
  };
}
