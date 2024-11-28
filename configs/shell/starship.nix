{ lib, config, ... }:
let
  lang = icon: color: {
    symbol = icon;
    format = "via [$symbol $version](${color}) ";
  };
  g = config._base;
  defaultShell = g.shell.default.package;
in
{
  programs.starship = {
    enable = true;
    enableTransience = defaultShell != g.shell.nushell.package;
    settings = {
      add_newline = false;
      scan_timeout = 10;
      command_timeout = 1000;
      line_break = {
        disabled = true;
      };
      fill = {
        symbol = " ";
      };
      format = lib.strings.concatStrings [
        "$all"
        "$fill"
        "$hostname"
        "$shlvl"
        " "
        "\n$container$character"
      ];
      status = {
        symbol = " ";
        not_found_symbol = " ";
        not_executable_symbol = " ";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:red) ";
        map_symbol = true;
        disabled = false;
      };
      time = {
        use_12hr = true;
        style = "yellow dimmed";
        format = "[$time]($style)";
        time_format = "%I:%M:%S";
      };
      hostname = {
        ssh_only = true;
        style = "white";
        format = "[$ssh_symbol$hostname]($style) ";
        disabled = false;
      };
      cmd_duration = {
        min_time = 1000;
        format = "[󰔛 $duration]($style) ";
        disabled = false;
      };
      character = {
        success_symbol = "[>](dimmed green) ";
        error_symbol = "[>](dimmed red) ";
        vimcmd_symbol = "[|](dimmed green) ";
        vimcmd_replace_one_symbol = "[-](dimmed purple) ";
        vimcmd_replace_symbol = "[|](dimmed blue) ";
        vimcmd_visual_symbol = "[|](dimmed yellow) ";
      };
      container = {
        symbol = "󰮄 ";
        format = "[$symbol]($style)";
      };
      directory.substitutions = {
        "~/data" = " ";
        "~/windows" = "󰖳 ";
      };
      git_branch = {
        symbol = "";
        format = "[$symbol $branch](fg:purple)(:$remote_branch) ";
        disabled = true;
      };
      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
        disabled = true;
      };
      os = {
        disabled = true;
        format = "$symbol";
        symbols = {
          Arch = "[ ](fg:bright-blue)";
          Debian = "[ ](fg:red)";
          EndeavourOS = "[ ](fg:purple)";
          Fedora = "[ ](fg:bright-blue)";
          NixOS = "[ ](fg:bright-blue)";
          openSUSE = "[ ](fg:green)";
          SUSE = "[ ](fg:green)";
          Ubuntu = "[ ](fg:bright-red)";
        };
      };
      shell = {
        format = "[$indicator]($style)";
        fish_indicator = "fish";
        bash_indicator = "bash";
        style = "yellow";
        disabled = true;
      };
      nix_shell = {
        disabled = false;
        format = "in [ $name](fg:white) ";
        impure_msg = "";
        # heuristic = true;
      };
      package = {
        format = "is [󰏗 $version](fg:bright-blue) ";
      };
      shlvl = {
        disabled = false;
        threshold = 2;
        format = "[󰶼 $shlvl](purple)";
      };
      python = lang "" "yellow";
      nodejs = lang " " "yellow";
      lua = lang "󰢱" "blue";
      rust = lang "" "red";
      java = lang "" "red";
      c = lang "" "blue";
      golang = lang "" "blue";
    };
  };
}
