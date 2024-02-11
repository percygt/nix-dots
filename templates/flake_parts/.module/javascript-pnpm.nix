{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.languages.javascript-pnpm;

  nodeModulesPath = "node_modules";

  initPnpmScript = pkgs.writeShellScript "init-pnpm.sh" ''
    function _devenv-pnpm-install()
    {
      # Avoid running "pnpm install" for every shell.
      # Only run it when the "pnpm-lock.yaml" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "pnpm-lock.yaml" in node_modules.
      local ACTUAL_PNPM_CHECKSUM="${cfg.package.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 ${cfg.pnpm.install.directory}/pnpm-lock.yaml)"
      local PNPM_CHECKSUM_FILE="${cfg.pnpm.install.directory}/${nodeModulesPath}/pnpm-lock.yaml.checksum"
      if [ -f "$PNPM_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_PNPM_CHECKSUM < "$PNPM_CHECKSUM_FILE"
        else
          EXPECTED_PNPM_CHECKSUM=""
      fi

      if [ "$ACTUAL_PNPM_CHECKSUM" != "$EXPECTED_PNPM_CHECKSUM" ]
      then
        if ${cfg.pnpm.package}/bin/pnpm install --dir ${cfg.pnpm.install.directory}
        then
          echo "$ACTUAL_PNPM_CHECKSUM" > "$PNPM_CHECKSUM_FILE"
        else
          echo "pnpm install failed. Run 'pnpm install' manually."
        fi
      fi
    }

    if [ ! -f ${cfg.pnpm.install.directory}/package.json ]
    then
      echo "No ${cfg.pnpm.install.directory}/package.json found. Run 'pnpm init' to create one." >&2
    else
      _devenv-pnpm-install
    fi
  '';
in {
  options.languages.javascript-pnpm = {
    enable = lib.mkEnableOption "tools for JavaScript development";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodejs;
      defaultText = lib.literalExpression "pkgs.nodejs";
      description = "The Node package to use.";
    };

    corepack = {
      enable = lib.mkEnableOption "shims for package managers besides npm";
    };

    pnpm = {
      enable = lib.mkEnableOption "pnpm";
      install = {
        enable = lib.mkEnableOption "pnpm install during devenv initialisation";
        directory = lib.mkOption {
          type = lib.types.str;
          description = "";
          default = config.devenv.root;
        };
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nodePackages.pnpm;
        defaultText = lib.literalExpression "pkgs.nodePackages.pnpm";
        description = "The pnpm package to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    languages.javascript-pnpm.pnpm.install.enable = lib.mkIf cfg.pnpm.enable (lib.mkDefault true);
    packages =
      [
        cfg.package
        cfg.pnpm.package
      ]
      ++ lib.optional cfg.pnpm.enable cfg.pnpm.package
      ++ lib.optional cfg.corepack.enable (pkgs.runCommand "corepack-enable" {} ''
        mkdir -p $out/bin
        ${cfg.package}/bin/corepack enable --install-directory $out/bin
      '');

    enterShell = lib.concatStringsSep "\n" (lib.optional cfg.pnpm.install.enable ''
      source ${initPnpmScript}
    '');
  };
}
