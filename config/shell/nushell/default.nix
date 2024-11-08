{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  nushellPkg = g.shell.nushell.package;
  configNu = "${g.flakeDirectory}/config/shell/nushell";
  t = config.modules.theme;
  c = t.colors.withHashtag;
  starshipCfg = config.programs.starship;
  tomlFormat = pkgs.formats.toml { };
  nushell-starship-settings = starshipCfg.settings // {
    character.disabled = true;
  };
in
{
  programs.nushell = {
    enable = true;
    package = nushellPkg;
    envFile.source = ./env.nu;
    configFile.source = ./config.nu;
    # extraConfig =
    #   lib.mkOrder 2000
    #     #nu
    #     ''
    #       let prev_completer = $env.config?.completions?.external?.completer? | default echo
    #       let next_completer = {|spans: list<string>|
    #         let expansion = scope aliases
    #         | where name == $spans.0
    #         | get -i 0.expansion
    #         | default $spans.0
    #         | split row " "
    #
    #         do $prev_completer ($spans | skip 1 | prepend $expansion)
    #       }
    #       $env.config = ($env.config?
    #       | default {}
    #       | merge { completions: { external: { completer: $next_completer } } })
    #     '';
    extraEnv =
      #nu
      ''
        $env.STARSHIP_CONFIG = "${config.xdg.configHome}/nushell/starship.toml"
        if (git rev-parse --is-inside-work-tree err> /dev/null | str contains 'true') {
            ${lib.getExe pkgs.onefetch}
        }
      '';
    shellAliases = config.home.shellAliases // {
      la = "ls -a";
      ll = "ls -la";
    };
  };

  xdg = {
    configFile = {
      "nushell/starship.toml" = lib.mkIf starshipCfg.enable {
        source = tomlFormat.generate "nushell-starship-config" nushell-starship-settings;
      };
      "nushell/nix-your-shell.nu".source = pkgs.nix-your-shell.generate-config "nu";
      "nushell/completer.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/completer.nu";
      "nushell/keybindings.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/keybindings.nu";
      "nushell/color_config.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/color_config.nu";
      "nushell/config-extra.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/config-extra.nu";
      "nushell/env-extra.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/env-extra.nu";
      "nushell/menus.nu".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/menus.nu";
      "nushell/modules".source = config.lib.file.mkOutOfStoreSymlink "${configNu}/modules";
      "nushell/base24-colorscheme.nu".text =
        #nu
        ''
          {
            base00: "${c.base00}"
            base01: "${c.base01}"
            base02: "${c.base02}"
            base03: "${c.base03}"
            base04: "${c.base04}"
            base05: "${c.base05}"
            base06: "${c.base06}"
            base07: "${c.base07}"
            base08: "${c.base08}"
            base09: "${c.base09}"
            base0A: "${c.base0A}"
            base0B: "${c.base0B}"
            base0C: "${c.base0C}"
            base0D: "${c.base0D}"
            base0E: "${c.base0E}"
            base0F: "${c.base0F}"
            base10: "${c.base10}"
            base11: "${c.base11}"
            base12: "${c.base12}"
            base13: "${c.base13}"
            base14: "${c.base14}"
            base15: "${c.base15}"
            base16: "${c.base16}"
            base17: "${c.base17}"
          }
        '';
    };
  };
}
